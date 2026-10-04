extends SceneTree

var failures := 0
var room: Node3D
var player: CharacterBody3D
var visual_review_directory := ""
var manual_playtest := false
var jump_buffer_only := false


func _initialize() -> void:
	# The renderer initializes its cache before user:// is redirected. Mirror only
	# its empty directory structure; never copy player saves or cache contents.
	var cache_directories: Array[String] = []
	for shader in DirAccess.get_directories_at("user://shader_cache"):
		for version in DirAccess.get_directories_at("user://shader_cache/" + shader):
			cache_directories.append("user://shader_cache/" + shader + "/" + version)
	ProjectSettings.set_setting("application/config/use_custom_user_dir", true)
	ProjectSettings.set_setting("application/config/custom_user_dir_name", "RifkinMovementTests")
	for directory in cache_directories:
		DirAccess.make_dir_recursive_absolute(directory)
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--visual-review="):
			visual_review_directory = argument.trim_prefix("--visual-review=")
		elif argument == "--manual-playtest":
			manual_playtest = true
		elif argument == "--jump-buffer-only":
			jump_buffer_only = true
	_run.call_deferred()


func _run() -> void:
	if not _check(DisplayServer.get_name() != "headless", "Movement checks use a rendered driver for real mouse capture"):
		quit(1)
		return
	room = load("res://office.tscn").instantiate()
	root.add_child(room)
	await _frames(10)
	if manual_playtest:
		DisplayServer.window_set_title("Rifkin Movement Playtest - isolated sandbox")
		print("Manual movement playtest: isolated user:// at ", OS.get_user_data_dir())
		return
	_check(Engine.physics_ticks_per_second == 60 and Engine.time_scale == 1.0, "The controller uses the existing 60 Hz physics contract")
	if jump_buffer_only:
		await _jump_buffering()
		_finish()
		return
	await _place(Vector3(-15, -6, -10))
	_key(KEY_W, true)
	await _frames(4)
	_check(_speed() > 1.4 and _speed() < 1.7, "Ground acceleration reaches the approved speed after four physics steps")
	await _frames(20)
	_check(absf(_speed() - 2.8) < 0.01, "Ordinary forward walking reaches 2.8 m/s")
	await _place(Vector3(-15, -6, -10))
	_key(KEY_W, true)
	_key(KEY_D, true)
	await _frames(30)
	_check(absf(_speed() - 2.8) < 0.01, "Ordinary diagonal walking stays at 2.8 m/s")
	_key(KEY_W, false)
	_key(KEY_D, false)
	await _frames(21)
	_check(_speed() < 0.01, "Ordinary walking stops within 0.35 seconds")
	await _jumping()
	await _jump_buffering()
	await _air_movement()
	await _transitions()
	await _collision_clearance()
	await _building_route(false)
	await _building_route(true)
	_finish()


func _jumping() -> void:
	await _place(Vector3(-15, -6, -10))
	_key(KEY_SPACE, true)
	await _frames(1)
	_check(player.velocity.y > 3.5 and not player.is_on_floor(), "Space launches a grounded jump")
	_key(KEY_SPACE, false)
	var maximum_height := 0.0
	var airborne_steps := 1
	for step in range(45):
		await _frames(1)
		maximum_height = maxf(maximum_height, player.global_position.y + 6.0)
		if player.is_on_floor():
			break
		airborne_steps += 1
	_check(maximum_height > 0.65 and maximum_height < 0.78 and airborne_steps >= 38 and airborne_steps <= 43, "A single jump follows the approved height and airtime")
	print("Observed jump: ", snappedf(maximum_height, 0.001), " m peak; ", airborne_steps, " airborne physics steps")
	await _frames(5)
	_check(player.is_on_floor(), "Releasing Space leaves the player landed")
	_key(KEY_SPACE, true)
	var launches := 0
	var rising := false
	for step in range(90):
		await _frames(1)
		if player.velocity.y > 0.0 and not rising:
			launches += 1
		rising = player.velocity.y > 0.0
	_check(launches >= 3 and launches <= 4, "Holding Space repeats only after landing")
	_key(KEY_SPACE, false)
	await _frames(45)
	# A quick press and release between ticks still produces one grounded jump.
	_key(KEY_SPACE, true)
	_key(KEY_SPACE, false)
	await _frames(1)
	_check(player.velocity.y > 3.5, "A brief Space press is consumed by the next physics step")


func _jump_buffering() -> void:
	await _place(Vector3(-15, -6, -10))
	_key(KEY_SPACE, true)
	await _frames(1)
	_key(KEY_SPACE, false)
	await _frames(35)
	player.velocity.x = 4.0
	_key(KEY_SPACE, true)
	_key(KEY_SPACE, false)
	var hops := 0
	var rising := false
	var carried_speed := 0.0
	for step in range(12):
		await _frames(1)
		if player.velocity.y > 0.0 and not rising:
			hops += 1
			carried_speed = _speed()
		rising = player.velocity.y > 0.0
	_check(hops == 1, "A released tap shortly before landing triggers one buffered hop")
	_check(absf(carried_speed - 4.0) < 0.01, "A buffered landing hop preserves horizontal momentum before friction")
	await _frames(45)
	_check(player.is_on_floor(), "The consumed tap does not repeat after its buffered hop")
	await _frames(30)
	_check(_speed() < 0.01, "Normal landing friction stops the carried momentum after a buffered hop")

	await _place(Vector3(-15, -6, -10))
	_key(KEY_SPACE, true)
	await _frames(1)
	_key(KEY_SPACE, false)
	await _frames(33)
	_key(KEY_SPACE, true)
	_key(KEY_SPACE, false)
	await _frames(2)
	_check(player.velocity.y < 0.0 and not player.is_on_floor(), "A buffered tap cannot jump while airborne")
	await _frames(12)
	_check(player.is_on_floor(), "A tap more than 120 ms before landing expires")

	await _place(Vector3(-15, -6, -10))
	_key(KEY_SPACE, true)
	await _frames(1)
	_key(KEY_SPACE, false)
	await _frames(39)
	_key(KEY_SPACE, true)
	_key(KEY_SPACE, false)
	room._open_notice()
	room._close_notice()
	await _frames(12)
	_check(player.is_on_floor(), "A walking pause clears a released prelanding tap")
	_key(KEY_SPACE, true)
	await _frames(1)
	_check(player.velocity.y > 3.5, "A fresh press still jumps after the buffered tap is cleared")
	_key(KEY_SPACE, false)


func _air_movement() -> void:
	await _place(Vector3(-15, -6, -10))
	_key(KEY_SPACE, true)
	await _frames(1)
	_key(KEY_SPACE, false)
	player.velocity.x = 4.0
	await _frames(8)
	_check(absf(_speed() - 4.0) < 0.01, "Releasing movement keys preserves airborne momentum")
	await _place(Vector3(-15, -6, -10))
	_key(KEY_W, true)
	await _frames(20)
	_key(KEY_SPACE, true)
	await _frames(80)
	_check(_speed() <= 2.81, "Straight forward jump chaining does not create strafe acceleration")
	await _place(Vector3(-15, -6, -10))
	player.rotation.y = PI / 2.0
	_key(KEY_W, true)
	await _frames(20)
	_key(KEY_SPACE, true)
	_key(KEY_D, true)
	var skilled_speed := 0.0
	for step in range(120):
		# Turn the real mouse-look controller while alternating the diagonal strafe.
		var right := step % 40 < 20
		_key(KEY_D, right)
		_key(KEY_A, not right)
		var mouse := InputEventMouseMotion.new()
		mouse.relative = Vector2(4.0 if right else -4.0, 0)
		Input.parse_input_event(mouse)
		Input.flush_buffered_events()
		await _frames(1)
		skilled_speed = maxf(skilled_speed, _speed())
	_check(skilled_speed > 3.5, "Coordinated strafe jumps and mouse turns gain speed beyond ordinary navigation")
	print("Observed strafe sequence: ", snappedf(skilled_speed, 0.001), " m/s peak")
	await _place(Vector3(-15, -6, -10))
	_key(KEY_SPACE, true)
	await _frames(1)
	_key(KEY_SPACE, false)
	player.velocity.x = 7.999
	_key(KEY_W, true)
	await _frames(3)
	_check(_speed() <= 8.0001, "Air acceleration respects the 8 m/s horizontal bound")
	await _place(Vector3(-15, -6, -10))
	player.velocity = Vector3(8, 0, 0)
	await _frames(30)
	_check(_speed() < 0.01, "Maximum-speed grounded momentum stops within 0.5 seconds")
	await _place(Vector3(-15, -6, -10))
	_key(KEY_SPACE, true)
	await _frames(1)
	player.velocity.x = 5.0
	await _frames(85)
	_check(absf(_speed() - 5.0) < 0.01, "Held jump chaining carries momentum through landing without ground friction")
	_key(KEY_SPACE, false)
	await _frames(70)
	_check(player.is_on_floor() and _speed() < 0.01, "Releasing jump chaining allows landing friction to stop the player")


func _transitions() -> void:
	await _place(Vector3(-15, -6, -10))
	_key(KEY_SPACE, true)
	await _frames(1)
	player.velocity.x = 5.0
	room._open_notice()
	room._close_notice()
	await _frames(50)
	_check(player.is_on_floor() and _speed() < 0.01, "Notice return clears momentum and requires a fresh jump press")
	await _place(Vector3(-2.72, 0, 3.33))
	_key(KEY_SPACE, true)
	await _frames(1)
	player.velocity.x = 5.0
	room.enter_workstation()
	await create_timer(0.45).timeout
	room.leave_workstation()
	await create_timer(0.5).timeout
	_check(player.active and player.is_on_floor() and _speed() < 0.01 and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED, "Workstation return restores mouse capture without carrying a held jump")
	await _place(Vector3(5.15, 0, -14.5))
	_key(KEY_SPACE, true)
	await _frames(1)
	player.velocity.x = 5.0
	room._use_elevator(room.elevator_controls[0])
	_check(not player.active and player.velocity.is_zero_approx(), "Elevator activation immediately pauses walking and clears momentum")
	await create_timer(1.2).timeout
	_check(player.active and player.is_on_floor() and absf(player.global_position.y + 6.0) < 0.06 and _speed() < 0.01, "Elevator arrival clears held jumping and restores supported walking")
	await _place(Vector3(-15, -6, -10))
	_key(KEY_SPACE, true)
	await _frames(1)
	player.velocity.x = 5.0
	_key(KEY_ESCAPE, true)
	_key(KEY_ESCAPE, false)
	await _frames(1)
	_check(Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and _speed() < 0.01 and player.velocity.y <= 0.0, "Releasing the mouse clears momentum and pending jumping")
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	Input.parse_input_event(click)
	Input.flush_buffered_events()
	click = click.duplicate()
	click.pressed = false
	Input.parse_input_event(click)
	Input.flush_buffered_events()
	await _frames(50)
	_check(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and player.is_on_floor(), "Recapturing the mouse does not resume a held jump")
	_key(KEY_SPACE, false)
	_key(KEY_SPACE, true)
	await _frames(1)
	_check(player.velocity.y > 3.5, "A fresh Space press jumps after a transition reset")


func _collision_clearance() -> void:
	await _place(Vector3(5.15, 0, -13.07))
	_key(KEY_SPACE, true)
	_key(KEY_SPACE, false)
	var maximum_height := 0.0
	var ceiling_contact := false
	for step in range(45):
		await _frames(1)
		maximum_height = maxf(maximum_height, player.global_position.y)
		ceiling_contact = ceiling_contact or player.is_on_ceiling()
	_check(ceiling_contact and maximum_height < 0.66 and player.is_on_floor(), "Elevator header stops an upward jump and permits safe landing")
	await _place(Vector3(5.15, 0, -14.5))
	_key(KEY_W, true)
	await _frames(60)
	_check(player.global_position.z > -15.65 and player.is_on_floor(), "The real controller cannot pass through the cab back wall")
	await _place(Vector3(-48.1, -6, -10))
	_key(KEY_SPACE, true)
	await _frames(1)
	player.velocity.x = -8.0
	_key(KEY_SPACE, false)
	await _frames(50)
	_check(player.global_position.x > -48.7 and player.is_on_floor() and _speed() < 0.01, "The solid exit stops airborne maximum-speed movement without tunnelling")


func _building_route(skilled: bool) -> void:
	var route := "Skilled" if skilled else "Ordinary"
	await _place(Vector3(-2.72, 0, 3.33))
	for waypoint in [Vector3(-2.72, 0, 4.15), Vector3(3.5, 0, 4.15), Vector3(3.5, 0, -6.3), Vector3(5.15, 0, -6.3)]:
		if not await _travel_to(waypoint, false, route + " office navigation"):
			return
	if not room.service_door_open:
		player.camera.look_at(room.service_door.to_global(room.service_door.get_aabb().get_center()))
		room.interact()
		await create_timer(0.4).timeout
	if not await _travel_to(Vector3(5.15, 0, -8.4), skilled, route + " staff doorway passage"):
		return
	for waypoint in [Vector3(5.15, 0, -9.5), Vector3(1.8, 0, -9.5)]:
		if not await _travel_to(waypoint, skilled, route + " break-room entry"):
			return
	await _capture("lesson-" + route.to_lower() + ".png", Vector3(-1, 1.2, -10.3))
	for waypoint in [Vector3(5.15, 0, -9.5), Vector3(5.15, 0, -14.5)]:
		if not await _travel_to(waypoint, skilled, route + " upper cab entry"):
			return
	await _capture("upper-cab-" + route.to_lower() + ".png", Vector3(5.15, 1.4, -13.07))
	if not await _ride(0, -6.0, route + " descent"):
		return
	if not await _travel_to(Vector3(5.15, -6, -10), skilled, route + " lower landing"):
		return
	await _capture("lower-cab-" + route.to_lower() + ".png", Vector3(5.15, -4.6, -13.07))
	if not await _travel_to(Vector3(-48.0, -6, -10), skilled, route + " full corridor to exit"):
		return
	await _capture("exit-" + route.to_lower() + ".png", Vector3(-48.7, -4.6, -10))
	for waypoint in [Vector3(5.15, -6, -10), Vector3(5.15, -6, -14.5)]:
		if not await _travel_to(waypoint, skilled, route + " return to lower cab"):
			return
	if not await _ride(1, 0.0, route + " ascent"):
		return
	for waypoint in [Vector3(5.15, 0, -8.4), Vector3(5.15, 0, -6.3), Vector3(3.5, 0, -6.3), Vector3(3.5, 0, 4.15), Vector3(-2.72, 0, 4.15), Vector3(-2.72, 0, 3.33)]:
		if not await _travel_to(waypoint, skilled, route + " supported return to workstation"):
			return
	player.camera.look_at(Vector3(-2.6, 1.168, 1.637))
	room.interact()
	await create_timer(0.45).timeout
	_check(room.workstation_active and room.workstation.visible, route + " round trip returns to the original workstation")
	room.leave_workstation()
	await create_timer(0.45).timeout


func _travel_to(target: Vector3, skilled: bool, description: String) -> bool:
	var peak_speed := 0.0
	var distance := Vector2(target.x - player.global_position.x, target.z - player.global_position.z).length()
	for step in range(int((distance / 2.8 + 3.0) * 60.0)):
		var remaining := Vector3(target.x - player.global_position.x, 0, target.z - player.global_position.z)
		if remaining.length() < 0.3:
			break
		var hopping := skilled and remaining.length() > 3.0
		var right := step % 40 < 20
		_key(KEY_W, true)
		_key(KEY_SPACE, hopping)
		_key(KEY_D, hopping and right)
		_key(KEY_A, hopping and not right)
		var heading := atan2(-remaining.x, -remaining.z)
		if hopping:
			heading += 0.12 * sin(float(step % 40) / 40.0 * TAU)
		var mouse := InputEventMouseMotion.new()
		mouse.relative = Vector2(-wrapf(heading - player.rotation.y, -PI, PI) / 0.002, player.camera.rotation.x / 0.002)
		Input.parse_input_event(mouse)
		Input.flush_buffered_events()
		await _frames(1)
		peak_speed = maxf(peak_speed, _speed())
	for key in [KEY_W, KEY_A, KEY_D, KEY_SPACE]:
		_key(key, false)
	await _frames(65 if skilled else 21)
	var remaining := Vector2(target.x - player.global_position.x, target.z - player.global_position.z).length()
	if remaining > 0.45 or not player.is_on_floor() or absf(player.global_position.y - target.y) > 0.06:
		printerr(description, " stopped at ", player.global_position, "; expected ", target)
	var reached := _check(remaining <= 0.45 and player.is_on_floor() and absf(player.global_position.y - target.y) < 0.06 and _speed() < 0.01, description)
	if skilled and distance > 30.0:
		_check(peak_speed > 3.5 and peak_speed <= 8.0001, "Skilled corridor traversal gains bounded speed using the real controller")
		print("Observed corridor peak: ", snappedf(peak_speed, 0.001), " m/s")
	return reached


func _ride(index: int, height: float, description: String) -> bool:
	var control: Node3D = room.elevator_controls[index].get_parent()
	player.camera.look_at(control.to_global(control.get_aabb().get_center()))
	var horizontal := Vector2(player.global_position.x, player.global_position.z)
	var view: Basis = player.camera.global_basis
	room.interact()
	_check(not player.active, description + " pauses walking at the reachable control")
	await create_timer(1.2).timeout
	return _check(player.active and player.is_on_floor() and absf(player.global_position.y - height) < 0.06 and Vector2(player.global_position.x, player.global_position.z).distance_to(horizontal) < 0.01 and player.camera.global_basis.is_equal_approx(view), description + " preserves horizontal position and view")


func _capture(filename: String, target: Vector3) -> void:
	if visual_review_directory.is_empty():
		return
	DirAccess.make_dir_recursive_absolute(visual_review_directory)
	player.camera.look_at(target)
	await process_frame
	await RenderingServer.frame_post_draw
	_check(root.get_texture().get_image().save_png(visual_review_directory.path_join(filename)) == OK, "Visual capture: " + filename)


func _place(position: Vector3) -> void:
	player = room.get_node("Player")
	player.active = false
	for key in [KEY_W, KEY_A, KEY_S, KEY_D, KEY_SPACE]:
		_key(key, false)
	player.global_position = position
	player.rotation = Vector3.ZERO
	player.camera.rotation = Vector3.ZERO
	player.velocity = Vector3.ZERO
	player.active = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await _frames(3)


func _frames(count: int) -> void:
	for step in range(count):
		await physics_frame
	await process_frame


func _key(code: Key, pressed: bool) -> void:
	if Input.is_physical_key_pressed(code) == pressed:
		return
	var event := InputEventKey.new()
	event.keycode = code
	event.physical_keycode = code
	event.pressed = pressed
	Input.parse_input_event(event)
	Input.flush_buffered_events()


func _speed() -> float:
	return Vector2(player.velocity.x, player.velocity.z).length()


func _check(condition: bool, description: String) -> bool:
	if condition:
		print("PASS: ", description)
	else:
		failures += 1
		printerr("FAIL: ", description)
	return condition


func _finish() -> void:
	room.queue_free()
	print("Movement integration: ", "PASS" if failures == 0 else "FAIL", " (", failures, " failures)")
	quit(0 if failures == 0 else 1)
