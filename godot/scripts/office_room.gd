extends Node3D

const INTERACTION_DISTANCE := 2.5
const TERMINAL_UI_SIZE := Vector2(1440, 900)
const PANOPTICON := preload("res://scripts/panopticon.gd")
const NOTICE_TEXT := "RIFKIN SOFTWARE / OPERATIONS / FLOOR 04\nPERIMETER RETENTION SYSTEM\nINSTALLATION NOTICE\n\nFollowing three recent accidents involving software engineers, perimeter retention nets have been installed.\n\nExtended shifts remain mandatory. Unscheduled absence is recorded by Panopticon. Please return to your assigned terminal.\n\nJoel / Operations\nPRESENCE IS A CONDITION OF EMPLOYMENT"

var workstation_active := false
var terminal: Area3D
var hud: Control
var prompt: Label
var clock_label: Label
var crosshair: Label
var monitor_screen: MeshInstance3D
var walking_camera: Transform3D
var zoom_tween: Tween
var panopticon: Node
var notice_area: Area3D
var notice_panel: PanelContainer
var window_glass: MeshInstance3D
var service_door: Node3D
var inside_cubicle := true
var nearby_terminals: Dictionary = {}
var look_seconds := {"window_looked": 0.0, "door_looked": 0.0}
var pending_observation := ""

@onready var office: Node3D = $Office
@onready var player: CharacterBody3D = $Player
@onready var workstation: Control = $CanvasLayer/Workstation

func _ready() -> void:
	for camera in office.find_children("*", "Camera3D", true, false):
		camera.current = false
	for light in office.find_children("*", "Light3D", true, false):
		# This GLB exports photometric intensities; Godot uses relative energy here.
		light.light_energy *= 0.0004
		light.shadow_enabled = true
	_add_world_collisions()
	_add_terminal()
	_add_environment()
	_build_hud()
	var spawn := office.find_child("PlayerSpawn", true, false) as Node3D
	player.global_position = spawn.global_position - Vector3(0.0, player.camera.position.y, 0.0)
	player.camera.current = true
	var direction: Vector3 = (terminal.global_position - player.camera.global_position).normalized()
	player.rotation.y = atan2(-direction.x, -direction.z)
	player.camera.rotation.x = asin(direction.y)
	workstation.return_to_office.connect(leave_workstation)
	leave_workstation()
	panopticon = PANOPTICON.new()
	panopticon.name = "Panopticon"
	add_child(panopticon)
	panopticon.setup(office, workstation)
	workstation.action_observed.connect(func(action: String): panopticon.observe_action(action))
	_add_notice()
	window_glass = office.find_child("Window safety glass", true, false) as MeshInstance3D
	service_door = office.find_child("Service door leaf", true, false) as Node3D
	workstation.clip_contents = true
	get_viewport().size_changed.connect(_resize_terminal_view)

func _add_world_collisions() -> void:
	for mesh in office.find_children("*", "MeshInstance3D", true, false):
		var object_name := String(mesh.name)
		if not (object_name == "Floor" or object_name.begins_with("Wall ") or object_name == "Ceiling backing"
			or "fabric partition" in object_name or "desk top" in object_name or "modesty panel" in object_name
			or "drawer pedestal" in object_name or "computer tower" in object_name
			or "chair seat" in object_name or "chair back" in object_name or "chair armrest" in object_name
			or object_name == "Archive cabinet" or object_name.begins_with("Archive cabinet_")
			or object_name == "Service door leaf" or object_name == "Window safety glass"):
			continue
		var bounds: AABB = mesh.get_aabb()
		var body := StaticBody3D.new()
		body.name = "Solid"
		var collision := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = bounds.size
		collision.shape = shape
		collision.position = bounds.get_center()
		body.add_child(collision)
		mesh.add_child(body)

func _add_terminal() -> void:
	var monitor := office.find_child("PlayerComputer", true, false).find_child("Player monitor housing", true, false) as MeshInstance3D
	monitor_screen = office.find_child("PlayerComputer", true, false).find_child("Player screen", true, false) as MeshInstance3D
	terminal = Area3D.new()
	terminal.name = "PlayerTerminal"
	terminal.collision_layer = 2
	terminal.collision_mask = 0
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = monitor.get_aabb().size + Vector3(0.02, 0.02, 0.02)
	collision.shape = shape
	terminal.add_child(collision)
	add_child(terminal)
	terminal.global_transform = monitor.global_transform

func _add_notice() -> void:
	var notice := office.find_child("WorkplaceNotice", true, false) as MeshInstance3D
	if notice == null:
		return
	notice_area = Area3D.new()
	notice_area.name = "BulletinNotice"
	notice_area.collision_layer = 2
	notice_area.collision_mask = 0
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = notice.get_aabb().size.max(Vector3(0.01, 0.01, 0.01))
	collision.shape = shape
	collision.position = notice.get_aabb().get_center()
	notice_area.add_child(collision)
	notice.add_child(notice_area)
	notice_panel = PanelContainer.new()
	notice_panel.name = "FacilitiesNotice"
	notice_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	notice_panel.position = Vector2(-310, -245)
	notice_panel.size = Vector2(620, 490)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.13, 0.11)
	style.content_margin_left = 28
	style.content_margin_right = 28
	style.content_margin_top = 28
	style.content_margin_bottom = 28
	notice_panel.add_theme_stylebox_override("panel", style)
	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 22)
	var text := Label.new()
	text.name = "NoticeText"
	text.text = NOTICE_TEXT
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text.add_theme_font_size_override("font_size", 20)
	layout.add_child(text)
	var close_button := Button.new()
	close_button.text = "Put the notice down [Esc]"
	close_button.pressed.connect(_close_notice)
	layout.add_child(close_button)
	notice_panel.add_child(layout)
	$CanvasLayer.add_child(notice_panel)
	notice_panel.hide()

func _open_notice() -> void:
	notice_panel.show()
	player.active = false
	player.velocity = Vector3.ZERO
	hud.hide()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_observe_away_action("notice_read")

func _close_notice() -> void:
	notice_panel.hide()
	_resume_walking()

func _add_environment() -> void:
	var world_environment := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.025, 0.035, 0.03)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.38, 0.43, 0.39)
	environment.ambient_light_energy = 0.22
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.ssao_enabled = true
	world_environment.environment = environment
	add_child(world_environment)

func _build_hud() -> void:
	hud = Control.new()
	hud.name = "RoomHUD"
	hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$CanvasLayer.add_child(hud)
	var title := Label.new()
	title.text = "RIFKIN SOFTWARE  /  OPERATIONS 04"
	title.position = Vector2(24, 20)
	title.add_theme_font_size_override("font_size", 18)
	hud.add_child(title)
	clock_label = Label.new()
	clock_label.position = Vector2(24, 47)
	hud.add_child(clock_label)
	var controls := Label.new()
	controls.text = "WASD  Move     Mouse  Look     E  Use computer / Read notice     Esc  Release mouse"
	controls.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	controls.position = Vector2(24, -48)
	hud.add_child(controls)
	prompt = Label.new()
	prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	prompt.position = Vector2(-220, 38)
	prompt.size = Vector2(440, 32)
	prompt.add_theme_font_size_override("font_size", 18)
	hud.add_child(prompt)
	crosshair = Label.new()
	crosshair.text = "+"
	crosshair.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	crosshair.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	crosshair.position = Vector2(-8, -12)
	crosshair.size = Vector2(16, 24)
	hud.add_child(crosshair)

func _physics_process(delta: float) -> void:
	if workstation_active or (notice_panel != null and notice_panel.visible):
		return
	var captured := Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	crosshair.visible = captured
	prompt.text = ""
	if not captured:
		prompt.text = "Click to return to the room"
	elif _target_is_terminal():
		prompt.text = "[E] Use your computer"
	elif _target_is_notice():
		prompt.text = "[E] Read facilities notice"
	if captured and player.active and (zoom_tween == null or not zoom_tween.is_running()):
		_observe_room(delta)
	var remaining: int = workstation.remaining_seconds
	clock_label.text = "Incident window  %02d:%02d" % [remaining / 60, remaining % 60]

func _unhandled_input(event: InputEvent) -> void:
	if notice_panel != null and notice_panel.visible:
		if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
			_close_notice()
			get_viewport().set_input_as_handled()
		return
	if workstation_active and not workstation.visible and event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		leave_workstation()
		get_viewport().set_input_as_handled()
		return
	if workstation_active or (zoom_tween != null and zoom_tween.is_running()):
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_E and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			interact()
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_viewport().set_input_as_handled()

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _target_is_terminal() -> bool:
	return _interaction_target() == terminal

func _target_is_notice() -> bool:
	return notice_area != null and _interaction_target() == notice_area

func _interaction_target() -> Object:
	var camera: Camera3D = player.camera
	var origin := camera.global_position
	var ray := PhysicsRayQueryParameters3D.create(origin, origin - camera.global_basis.z * INTERACTION_DISTANCE, 3, [player.get_rid()])
	ray.collide_with_areas = true
	var hit := get_world_3d().direct_space_state.intersect_ray(ray)
	return hit.get("collider")

func interact() -> void:
	if workstation_active or (notice_panel != null and notice_panel.visible) or (zoom_tween != null and zoom_tween.is_running()):
		return
	if _target_is_terminal():
		enter_workstation()
	elif _target_is_notice():
		_open_notice()

func _observe_room(delta: float) -> void:
	var position_in_cubicle := player.global_position.x > -4.15 and player.global_position.x < -1.05 and player.global_position.z > 1.2 and player.global_position.z < 3.625
	if inside_cubicle and not position_in_cubicle:
		_observe_away_action("cubicle_left")
	inside_cubicle = position_in_cubicle
	for terminal_id in panopticon.alerts:
		if terminal_id == "04":
			continue
		var nearby: bool = player.camera.global_position.distance_to(panopticon.alerts[terminal_id].global_position) < 1.8
		if nearby and not nearby_terminals.get(terminal_id, false):
			panopticon.observe_action("terminal_passed", terminal_id)
		nearby_terminals[terminal_id] = nearby
	for action in look_seconds:
		var target: Node3D = window_glass if action == "window_looked" else service_door
		if target == null:
			continue
		var toward: Vector3 = target.global_position - player.camera.global_position
		var looking: bool = toward.length() < 3.5 and (-player.camera.global_basis.z).dot(toward.normalized()) > 0.88
		if action == "window_looked":
			looking = _interaction_target() == window_glass.get_node("Solid")
		look_seconds[action] = float(look_seconds[action]) + delta if looking else 0.0
		if float(look_seconds[action]) >= 1.5:
			_observe_away_action(action)
			look_seconds[action] = -20.0

func _observe_away_action(action: String) -> void:
	pending_observation = action
	panopticon.observe_action(action)

func enter_workstation() -> void:
	if pending_observation.is_empty():
		panopticon.observe_action("workstation_entered")
	else:
		panopticon.show_alert("04", PANOPTICON.ACTION_MESSAGES[pending_observation])
		panopticon.last_reactive_notice["04"] = Time.get_ticks_msec() / 1000.0
		pending_observation = ""
	walking_camera = player.camera.transform
	workstation_active = true
	player.active = false
	player.velocity = Vector3.ZERO
	hud.hide()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	zoom_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	zoom_tween.tween_property(player.camera, "global_transform", _terminal_camera_transform(), 0.35)
	zoom_tween.tween_callback(func():
		_update_terminal_projection()
		workstation.show()
	)

func leave_workstation() -> void:
	var was_at_workstation := workstation_active
	workstation_active = false
	workstation.hide()
	if zoom_tween != null:
		zoom_tween.kill()
	if was_at_workstation:
		_observe_away_action("workstation_left")
		zoom_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		zoom_tween.tween_property(player.camera, "transform", walking_camera, 0.35)
		zoom_tween.tween_callback(_resume_walking)
	else:
		_resume_walking()

func _resume_walking() -> void:
	player.active = true
	hud.show()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _terminal_camera_transform() -> Transform3D:
	var camera: Camera3D = player.camera
	var viewport_size := get_viewport().get_visible_rect().size
	var half_fov := tan(deg_to_rad(camera.fov) * 0.5)
	var aspect := viewport_size.x / viewport_size.y
	# Fill the view with the physical bezel while keeping the entire glass visible.
	var distance: float = max(0.73 / (0.985 * 2.0 * half_fov * aspect), 0.411 / (0.9 * 2.0 * half_fov))
	var target := Transform3D(Basis.IDENTITY, monitor_screen.global_position + monitor_screen.global_basis.y.normalized() * distance)
	return target.looking_at(monitor_screen.global_position, -monitor_screen.global_basis.z.normalized())

func _update_terminal_projection() -> void:
	var bounds := monitor_screen.get_aabb()
	var glass := Rect2(player.camera.unproject_position(monitor_screen.to_global(bounds.position)), Vector2.ZERO)
	for corner in range(8):
		glass = glass.expand(player.camera.unproject_position(monitor_screen.to_global(bounds.get_endpoint(corner))))
	workstation.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	workstation.position = glass.position
	workstation.size = TERMINAL_UI_SIZE
	workstation.scale = glass.size / TERMINAL_UI_SIZE

func _resize_terminal_view() -> void:
	if workstation.visible:
		player.camera.global_transform = _terminal_camera_transform()
		_update_terminal_projection()
