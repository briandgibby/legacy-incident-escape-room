extends Node

const EYE := preload("res://assets/office/panopticon_eye.svg")
const TERMINALS := ["04", "05", "07", "08", "11", "12"]
const MESSAGES := [
	"Joel is watching you.\nScreen observation is active.",
	"Joel is viewing this screen.\nPanopticon monitoring is active.",
	"Presence confirmed.\nJoel has requested no further action.",
	"Joel has completed this review.\nPlease continue as normal.",
]
const ALERT_SECONDS := 6.0
const EYE_SECONDS := 8.0
const REACTIVE_COOLDOWN_SECONDS := 22.0
const CONTEXT_COOLDOWN_SECONDS := 60.0
const ACTION_MESSAGES := {
	"typing": "Joel can see your revisions.\nKeystroke activity has resumed.",
	"draft_saved": "Joel has received your draft.\nEarlier revisions remain on record.",
	"clue_read": "Joel knows which records you opened.\nDocument access has been acknowledged.",
	"hint_requested": "Joel has noted your request for assistance.\nPlease improve your independence.",
	"simulate": "Joel is reviewing your trial run.\nThis attempt will remain on record.",
	"tests_failed": "Joel has reviewed your failed tests.\nThe attempt has been added to your record.",
	"tests_passed": "Joel has reviewed your test results.\nFurther effort is expected.",
	"deploy_rejected": "Joel has reviewed the rejected deployment.\nPlease remain at your workstation.",
	"deploy_accepted": "Joel has acknowledged the deployment.\nYour shift has not ended.",
	"sandbox_reset": "Joel can still see your earlier attempts.\nResetting does not clear your record.",
	"status_checked": "Joel is watching your progress.\nPlease avoid unnecessary status checks.",
	"case_file_viewed": "Joel has noted your return to the case file.\nReading time is included in your review.",
	"editor_opened": "Joel is watching your editor.\nPlease resume productive activity.",
	"terminal_opened": "Joel is viewing your terminal.\nCommand activity is being observed.",
	"helper_opened": "Joel has noted your use of the helper.\nAssistance time is included in your review.",
	"workstation_entered": "Joel has joined this session.\nPresence confirmed. No action required.",
	"workstation_left": "Joel has acknowledged your absence.\nYour session remains under observation.",
	"cubicle_left": "Joel has noted that your chair is empty.\nAbsence time is being recorded.",
	"window_looked": "Joel has noted your interest in the window.\nThe new safety measures are for your benefit.",
	"notice_read": "Joel confirms that you have read the notice.\nAcknowledgment is automatic.",
	"door_looked": "Joel is waiting.\nPlease face your monitor.",
	"terminal_passed": "Joel has joined this session.\nYour presence has been acknowledged.",
}
const PRIORITY_ACTIONS := ["tests_failed", "tests_passed", "deploy_rejected", "deploy_accepted", "workstation_left", "cubicle_left", "window_looked", "notice_read", "door_looked"]
const CONTEXT_ACTIONS := ["cubicle_left", "window_looked", "notice_read", "door_looked", "terminal_passed"]

var alerts: Dictionary = {}
var timers: Dictionary = {}
var hide_timers: Dictionary = {}
var eye_timers: Dictionary = {}
var return_timers: Dictionary = {}
var last_reactive_notice: Dictionary = {}
var last_priority_notice: Dictionary = {}
var last_context_notice: Dictionary = {}
var disconnected_terminals: Dictionary = {}
var player_toast: PanelContainer
var player_message: Label
var player_eye: TextureRect
var player_lingering_eye: TextureRect
var typing_idle_timer: Timer
var keyboard_taps: AudioStreamPlayer3D
var blink_tween: Tween
var last_keyboard_tap := -45.0
var random := RandomNumberGenerator.new()

func setup(office: Node3D, workstation: Control) -> void:
	random.randomize()
	_build_player_toast(workstation)
	typing_idle_timer = Timer.new()
	typing_idle_timer.one_shot = true
	typing_idle_timer.timeout.connect(_typing_stopped)
	add_child(typing_idle_timer)
	keyboard_taps = AudioStreamPlayer3D.new()
	keyboard_taps.name = "VacantKeyboardTaps"
	keyboard_taps.stream = _keyboard_tap_stream()
	keyboard_taps.volume_db = -24.0
	keyboard_taps.max_distance = 9.0
	office.add_child(keyboard_taps)
	var vacant_terminal := office.find_child("BackgroundComputer05*", true, false)
	var vacant_screen := vacant_terminal.find_child("Vacant05 screen*", true, false) as MeshInstance3D
	keyboard_taps.global_position = vacant_screen.global_position
	for terminal_id in TERMINALS:
		var terminal_name := "PlayerComputer*" if terminal_id == "04" else "BackgroundComputer%s*" % terminal_id
		var terminal := office.find_child(terminal_name, true, false)
		var screen_name := "Player screen*" if terminal_id == "04" else "Vacant%s screen*" % terminal_id
		var screen := terminal.find_child(screen_name, true, false) as MeshInstance3D
		var alert := _build_screen_alert(screen, terminal_id)
		alerts[terminal_id] = alert
		var hide_timer := Timer.new()
		hide_timer.one_shot = true
		hide_timer.timeout.connect(_expire_text.bind(terminal_id))
		add_child(hide_timer)
		hide_timers[terminal_id] = hide_timer
		var eye_timer := Timer.new()
		eye_timer.one_shot = true
		eye_timer.timeout.connect(dismiss_alert.bind(terminal_id))
		add_child(eye_timer)
		eye_timers[terminal_id] = eye_timer
		var return_timer := Timer.new()
		return_timer.one_shot = true
		return_timer.timeout.connect(_observer_returned.bind(terminal_id))
		add_child(return_timer)
		return_timers[terminal_id] = return_timer
		var timer := Timer.new()
		timer.one_shot = true
		timer.timeout.connect(_scheduled_alert.bind(terminal_id))
		add_child(timer)
		timers[terminal_id] = timer
		timer.start(random.randf_range(12.0, 28.0))

func _scheduled_alert(terminal_id: String) -> void:
	if random.randf() < 0.05:
		show_alert(terminal_id, "Observer disconnected.\nSession observation remains active.")
		disconnected_terminals[terminal_id] = true
		(return_timers[terminal_id] as Timer).start(random.randf_range(24.0, 36.0))
	else:
		show_alert(terminal_id)
	(timers[terminal_id] as Timer).start(random.randf_range(35.0, 70.0))

func observe_action(action: String, terminal_id: String = "04") -> void:
	if action == "typing":
		typing_idle_timer.start(1.8)
	if not ACTION_MESSAGES.has(action):
		return
	var now := Time.get_ticks_msec() / 1000.0
	var context_key := "%s:%s" % [terminal_id, action]
	if action in CONTEXT_ACTIONS and now - float(last_context_notice.get(context_key, -CONTEXT_COOLDOWN_SECONDS)) < CONTEXT_COOLDOWN_SECONDS:
		return
	var priority := action in PRIORITY_ACTIONS
	var notice_times := last_priority_notice if priority else last_reactive_notice
	if now - float(notice_times.get(terminal_id, -REACTIVE_COOLDOWN_SECONDS)) < REACTIVE_COOLDOWN_SECONDS:
		return
	last_reactive_notice[terminal_id] = now
	if priority:
		last_priority_notice[terminal_id] = now
	if action in CONTEXT_ACTIONS:
		last_context_notice[context_key] = now
	show_alert(terminal_id, ACTION_MESSAGES[action])

func show_alert(terminal_id: String, message: String = "") -> void:
	if message.is_empty():
		message = MESSAGES[random.randi_range(0, MESSAGES.size() - 1)]
	disconnected_terminals.erase(terminal_id)
	(return_timers[terminal_id] as Timer).stop()
	(eye_timers[terminal_id] as Timer).stop()
	var alert: Node3D = alerts[terminal_id]
	(alert.get_node("Message") as Label3D).text = message
	for part in ["NotificationCard", "Title", "Message", "Eye"]:
		(alert.get_node(part) as Node3D).show()
	alert.show()
	(hide_timers[terminal_id] as Timer).start(ALERT_SECONDS)
	if terminal_id == "04":
		player_message.text = message
		player_lingering_eye.hide()
		player_toast.show()

func _expire_text(terminal_id: String) -> void:
	var alert: Node3D = alerts[terminal_id]
	for part in ["NotificationCard", "Title", "Message"]:
		(alert.get_node(part) as Node3D).hide()
	(eye_timers[terminal_id] as Timer).start(40.0 if disconnected_terminals.has(terminal_id) else EYE_SECONDS)
	if terminal_id == "04":
		player_toast.hide()
		player_lingering_eye.show()

func _observer_returned(terminal_id: String) -> void:
	show_alert(terminal_id, "Joel is still here.\nPlease continue as normal.")

func dismiss_alert(terminal_id: String) -> void:
	(alerts[terminal_id] as Node3D).hide()
	(hide_timers[terminal_id] as Timer).stop()
	(eye_timers[terminal_id] as Timer).stop()
	(return_timers[terminal_id] as Timer).stop()
	disconnected_terminals.erase(terminal_id)
	if terminal_id == "04":
		player_toast.hide()
		player_lingering_eye.hide()

func _typing_stopped() -> void:
	if (alerts["04"] as Node3D).visible:
		if blink_tween:
			blink_tween.kill()
		blink_tween = create_tween()
		blink_tween.tween_method(_set_eye_open, 1.0, 0.08, 0.10)
		blink_tween.tween_method(_set_eye_open, 0.08, 1.0, 0.14)
	var now := Time.get_ticks_msec() / 1000.0
	if now - last_keyboard_tap >= 45.0:
		keyboard_taps.play()
		last_keyboard_tap = now

func _set_eye_open(openness: float) -> void:
	(alerts["04"] as Node3D).get_node("Eye").scale.y = openness
	player_eye.scale.y = openness
	player_lingering_eye.scale.y = openness

func _keyboard_tap_stream() -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 22050
	var samples := int(stream.mix_rate * 0.16)
	var data := PackedByteArray()
	data.resize(samples * 2)
	for i in samples:
		var moment := float(i) / stream.mix_rate
		var amplitude := 0.0
		for onset in [0.0, 0.075]:
			var age: float = moment - onset
			if age >= 0.0 and age < 0.035:
				amplitude += (random.randf_range(-1.0, 1.0) * 0.6 + sin(age * TAU * 1800.0) * 0.4) * exp(-age * 180.0)
		data.encode_s16(i * 2, int(clampf(amplitude, -1.0, 1.0) * 20000.0))
	stream.data = data
	return stream

func _build_screen_alert(screen: MeshInstance3D, terminal_id: String) -> Node3D:
	var alert := Node3D.new()
	alert.name = "Panopticon%s" % terminal_id
	# The imported glass lies in local XZ; its local Y faces the viewer.
	alert.rotation.x = -PI / 2.0
	alert.position = Vector3(0.153, 0.003, 0.128)
	screen.add_child(alert)
	var card := MeshInstance3D.new()
	card.name = "NotificationCard"
	var quad := QuadMesh.new()
	quad.size = Vector2(0.31, 0.12)
	card.mesh = quad
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color(0.027, 0.058, 0.044)
	card.material_override = material
	alert.add_child(card)
	var eye := Sprite3D.new()
	eye.name = "Eye"
	eye.texture = EYE
	eye.pixel_size = 0.00043
	eye.position = Vector3(-0.132, 0.037, 0.001)
	eye.shaded = false
	alert.add_child(eye)
	var title := _screen_label("PANOPTICON", 24, Color(0.73, 0.9, 0.72))
	title.name = "Title"
	title.position = Vector3(-0.11, 0.045, 0.001)
	alert.add_child(title)
	var message := _screen_label("", 20, Color(0.8, 0.86, 0.78))
	message.name = "Message"
	message.position = Vector3(-0.14, 0.006, 0.001)
	alert.add_child(message)
	alert.hide()
	return alert

func _screen_label(text: String, font_size: int, color: Color) -> Label3D:
	var label := Label3D.new()
	label.text = text
	label.font_size = font_size
	label.pixel_size = 0.0005
	label.modulate = color
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	label.outline_size = 0
	label.shaded = false
	return label

func _build_player_toast(workstation: Control) -> void:
	player_toast = PanelContainer.new()
	player_toast.name = "PanopticonAlert"
	player_toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	player_toast.z_index = 10
	workstation.add_child(player_toast)
	player_toast.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	player_toast.offset_left = -458
	player_toast.offset_top = -144
	player_toast.offset_right = -18
	player_toast.offset_bottom = -18
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.027, 0.058, 0.044, 0.98)
	style.border_color = Color(0.3, 0.44, 0.32)
	style.set_border_width_all(1)
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	player_toast.add_theme_stylebox_override("panel", style)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	player_toast.add_child(content)
	var heading := HBoxContainer.new()
	heading.add_theme_constant_override("separation", 12)
	content.add_child(heading)
	player_eye = TextureRect.new()
	player_eye.texture = EYE
	player_eye.custom_minimum_size = Vector2(32, 32)
	player_eye.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	player_eye.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	player_eye.pivot_offset = Vector2(16, 16)
	heading.add_child(player_eye)
	var title := Label.new()
	title.text = "PANOPTICON  /  TERMINAL 04"
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(0.73, 0.9, 0.72))
	heading.add_child(title)
	player_message = Label.new()
	player_message.add_theme_font_size_override("font_size", 16)
	player_message.add_theme_color_override("font_color", Color(0.8, 0.86, 0.78))
	player_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(player_message)
	for child in player_toast.find_children("*", "Control", true, false):
		child.mouse_filter = Control.MOUSE_FILTER_IGNORE
	player_toast.hide()
	player_lingering_eye = TextureRect.new()
	player_lingering_eye.name = "PanopticonLingeringEye"
	player_lingering_eye.texture = EYE
	player_lingering_eye.mouse_filter = Control.MOUSE_FILTER_IGNORE
	player_lingering_eye.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	player_lingering_eye.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	player_lingering_eye.pivot_offset = Vector2(16, 16)
	player_lingering_eye.z_index = 10
	workstation.add_child(player_lingering_eye)
	player_lingering_eye.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	player_lingering_eye.offset_left = -66
	player_lingering_eye.offset_top = -66
	player_lingering_eye.offset_right = -34
	player_lingering_eye.offset_bottom = -34
	player_lingering_eye.hide()
