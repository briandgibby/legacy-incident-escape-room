extends SceneTree

var failures := 0


func _initialize() -> void:
	# Redirect user:// before the workstation creates its incident sandbox.
	ProjectSettings.set_setting("application/config/use_custom_user_dir", true)
	ProjectSettings.set_setting("application/config/custom_user_dir_name", "RifkinGameplayTests")
	_run.call_deferred()


func _run() -> void:
	if not _check(FileAccess.file_exists("res://office.tscn"), "The game starts in the playable office"):
		quit(1)
		return
	var scene: PackedScene = load("res://office.tscn")
	var room = scene.instantiate()
	root.add_child(room)
	await physics_frame
	await physics_frame
	var workstation = room.get_node("CanvasLayer/Workstation")
	var player: CharacterBody3D = room.get_node("Player")
	var camera: Camera3D = player.get_node("Camera3D")
	_check(not room.workstation_active and not workstation.visible, "Start at the cubicle, outside the terminal")
	_check(camera.current, "The first-person camera is active")
	_check(workstation.has_signal("return_to_office"), "Workstation provides a way back to the room")
	var monitoring = room.get_node("Panopticon")
	_check(monitoring.alerts.size() == 6 and monitoring.timers.size() == 6, "Panopticon monitors all six terminals")
	var initial_intervals: Array[float] = []
	var schedules_running := true
	for terminal_id in ["04", "05", "07", "08", "11", "12"]:
		var alert: Node3D = monitoring.alerts[terminal_id]
		monitoring.show_alert(terminal_id)
		_check(alert.visible and alert.get_node("Eye").texture != null and "Joel" in alert.get_node("Message").text, "Terminal " + terminal_id + " displays Joel's monitoring alert and eye icon")
		var schedule: Timer = monitoring.timers[terminal_id]
		schedules_running = schedules_running and schedule.one_shot and schedule.time_left > 0
		if schedule.wait_time not in initial_intervals:
			initial_intervals.append(schedule.wait_time)
		monitoring.dismiss_alert(terminal_id)
		_check(not alert.visible, "Terminal " + terminal_id + " dismisses the alert")
	_check(schedules_running and initial_intervals.size() > 1, "Terminals schedule alerts independently at randomized intervals")
	monitoring.show_alert("04")
	_check(monitoring.player_toast.visible and "Joel" in monitoring.player_message.text, "The player's desktop mirrors the monitoring notification")
	var mouse_transparent: bool = monitoring.player_toast.mouse_filter == Control.MOUSE_FILTER_IGNORE
	for child in monitoring.player_toast.find_children("*", "Control", true, false):
		mouse_transparent = mouse_transparent and child.mouse_filter == Control.MOUSE_FILTER_IGNORE
	_check(mouse_transparent, "Panopticon notifications do not capture mouse input")
	monitoring.hide_timers["04"].timeout.emit()
	_check(not monitoring.player_toast.visible and monitoring.alerts["04"].visible and monitoring.player_lingering_eye.visible, "Alert text expires while the monitoring eye remains")
	monitoring.eye_timers["04"].timeout.emit()
	monitoring._scheduled_alert("05")
	_check(monitoring.timers["05"].one_shot and monitoring.timers["05"].time_left > 0, "Monitoring schedules another alert after a notification")
	monitoring.dismiss_alert("05")

	# Look at the actual monitor, rather than the asset's origin-only marker.
	camera.look_at(Vector3(-2.6, 1.168, 1.637))
	var walking_camera: Transform3D = camera.transform
	var walking_body: Transform3D = player.global_transform
	# Headless Godot cannot capture the mouse, so invoke the interaction directly.
	room.interact()
	await create_timer(0.45).timeout
	_check(room.workstation_active and workstation.visible, "The player's computer opens the incident workstation")
	_check(not player.active, "Room movement is disabled at the workstation")
	_check(camera.global_position.distance_to(Vector3(-2.6, 1.168, 1.637)) < 0.5, "The terminal uses a close first-person camera view")
	_check(player.global_transform.is_equal_approx(walking_body), "Leaning toward the monitor does not teleport the player")
	var screen: MeshInstance3D = room.get_node("Office").find_child("Player screen", true, false)
	var bounds := screen.get_aabb()
	var top_left := camera.unproject_position(screen.to_global(bounds.position))
	var bottom_right := camera.unproject_position(screen.to_global(bounds.end))
	var glass := Rect2(top_left, bottom_right - top_left)
	var interface_rect: Rect2 = workstation.get_global_rect()
	_check(interface_rect.position.distance_to(glass.position) < 2.0 and interface_rect.size.distance_to(glass.size) < 3.0, "The interface stays inside the physical monitor glass")
	var original_window_size := root.size
	root.size = Vector2i(1280, 960)
	await process_frame
	await process_frame
	_check(root.get_visible_rect().encloses(workstation.get_global_rect()), "The whole desktop remains inside the monitor view after resizing")
	root.size = original_window_size
	await process_frame
	await process_frame
	var tabs: TabContainer = workstation.editor.get_parent().get_parent()
	tabs.current_tab = 1
	workstation.editor.grab_focus()
	monitoring.show_alert("04")
	_check(workstation.editor.has_focus(), "A monitoring alert preserves keyboard focus in the editor")
	monitoring.dismiss_alert("04")
	var original_workstation = workstation
	workstation.editor.text += "\n// Integration-test draft"
	var draft: String = workstation.editor.text
	workstation._open_clue(workstation.level.clues[0])
	var clue_count: int = workstation.discovered_clues.size()
	var elapsed: int = workstation.elapsed_seconds
	var return_button: Button = workstation.find_child("ReturnToOffice", true, false)
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.position = return_button.get_global_rect().get_center()
	click.global_position = click.position
	click.pressed = true
	root.push_input(click, true)
	var release := click.duplicate() as InputEventMouseButton
	release.pressed = false
	root.push_input(release, true)
	_check(not room.workstation_active and not workstation.visible, "Return to office closes the terminal")
	await create_timer(1.1).timeout
	_check(camera.transform.is_equal_approx(walking_camera), "Leaving the monitor restores the walking camera")
	_check(workstation.elapsed_seconds > elapsed, "The incident clock continues while walking in the office")
	room.interact()
	await create_timer(0.45).timeout
	_check(room.workstation_active, "The terminal can be reopened")
	_check(room.get_node("CanvasLayer/Workstation") == original_workstation, "Returning preserves the workstation instance")
	_check(workstation.editor.text == draft, "Returning preserves an unsaved editor draft")
	_check(workstation.discovered_clues.size() == clue_count, "Returning preserves discovered clues")
	var escape := InputEventKey.new()
	escape.keycode = KEY_ESCAPE
	escape.pressed = true
	workstation._input(escape)
	_check(not room.workstation_active, "Escape returns from the workstation")
	await create_timer(0.45).timeout
	room.enter_workstation()
	room._unhandled_input(escape)
	await create_timer(0.45).timeout
	_check(not room.workstation_active and not workstation.visible and camera.transform.is_equal_approx(walking_camera), "Escape during the approach cancels the zoom without reopening the desktop")

	# Background station 05 has the same shape but must never open the workstation.
	player.global_position = Vector3(1.0, 0.1, 3.33)
	camera.look_at(Vector3(1.0, 1.168, 1.637))
	await physics_frame
	room.interact()
	_check(not room.workstation_active, "Other office terminals remain unusable")
	player.global_position = Vector3(-2.6, 0.1, 0.35)
	camera.look_at(Vector3(-2.6, 1.168, 1.637))
	await physics_frame
	room.interact()
	_check(not room.workstation_active, "Cubicle partitions block interaction through the wall")
	player.global_position = Vector3(-2.6, 0.1, 5.0)
	camera.look_at(Vector3(-2.6, 1.168, 1.637))
	await physics_frame
	room.interact()
	_check(not room.workstation_active, "The player must be within reach of the computer")

	# Check real physics, without depending on keyboard event timing.
	player.global_position = Vector3(-2.72, 0.1, 3.33)
	player.velocity = Vector3.ZERO
	var collision := player.move_and_collide(Vector3(0, 0, -2))
	_check(collision != null, "The player cannot walk through the cubicle desk")
	player.global_position = Vector3(6.5, 0.1, 0)
	collision = player.move_and_collide(Vector3(2, 0, 0))
	_check(collision != null, "The player cannot walk through the office wall")
	player.global_position = Vector3(0, 0.1, 4.8)
	collision = player.move_and_collide(Vector3(0, -2, 0))
	_check(collision != null, "The office floor supports the player")

	room.queue_free()
	await process_frame
	print("Gameplay integration: ", "PASS" if failures == 0 else "FAIL", " (", failures, " failures)")
	quit(0 if failures == 0 else 1)


func _check(condition: bool, description: String) -> bool:
	if condition:
		print("PASS: ", description)
	else:
		failures += 1
		printerr("FAIL: ", description)
	return condition
