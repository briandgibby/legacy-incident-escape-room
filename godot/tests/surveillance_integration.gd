extends SceneTree

var failures := 0


func _initialize() -> void:
	# Protect the player's working copy when the workstation resets its sandbox.
	ProjectSettings.set_setting("application/config/use_custom_user_dir", true)
	ProjectSettings.set_setting("application/config/custom_user_dir_name", "RifkinSurveillanceTests")
	_run.call_deferred()


func _run() -> void:
	var scene: PackedScene = load("res://office.tscn")
	var room = scene.instantiate()
	root.add_child(room)
	await physics_frame
	await physics_frame
	var workstation = room.get_node("CanvasLayer/Workstation")
	var player: CharacterBody3D = room.get_node("Player")
	var camera: Camera3D = player.get_node("Camera3D")
	var monitoring = room.get_node_or_null("Panopticon")
	var interfaces_ready := workstation.has_signal("action_observed") and monitoring != null and monitoring.has_method("observe_action")
	_check(interfaces_ready, "Workstation actions connect to reactive Panopticon observation")
	if not interfaces_ready:
		_finish(room)
		return

	var observed: Array[String] = []
	workstation.action_observed.connect(func(action: String): observed.append(action))
	room.enter_workstation()
	await create_timer(0.45).timeout
	var tabs: TabContainer = workstation.editor.get_parent().get_parent()
	tabs.current_tab = 1
	workstation.editor.grab_focus()
	workstation.editor.insert_text_at_caret("// Surveillance verification\n")
	await process_frame
	_check("typing" in observed, "Editing a visible workstation draft reports typing")
	workstation._open_clue(workstation.level.clues[0])
	workstation._save_editor_file()
	_check("clue_read" in observed and "draft_saved" in observed, "Reading evidence and saving a draft report their actual actions")
	monitoring.last_priority_notice.clear()
	workstation._run_runner("test")
	_check("tests_failed" in observed and "ERR_ASSERTION" in workstation.terminal_output.text, "The unchanged broken incident reports its real failing tests")
	var failed_message: String = monitoring.player_message.text
	_check("Joel" in failed_message and "reviewed" in failed_message and "failed tests" in failed_message, "The real failed attempt reaches Joel's specific review notice")
	monitoring.observe_action("tests_passed")
	_check(monitoring.player_message.text == failed_message, "Repeated actions cannot flood or immediately replace Joel's notice")
	var mouse_transparent: bool = monitoring.player_toast.mouse_filter == Control.MOUSE_FILTER_IGNORE
	for child in monitoring.player_toast.find_children("*", "Control", true, false):
		mouse_transparent = mouse_transparent and child.mouse_filter == Control.MOUSE_FILTER_IGNORE
	_check(mouse_transparent and workstation.editor.has_focus(), "Reactive notices preserve editor focus and allow mouse input through")
	monitoring.hide_timers["04"].timeout.emit()
	var alert: Node3D = monitoring.alerts["04"]
	_check(alert.visible and alert.get_node("Eye").visible and not alert.get_node("Message").visible and not monitoring.player_toast.visible and monitoring.player_lingering_eye.visible, "The message expires while the watching eye lingers on the glass and desktop")
	monitoring.eye_timers["04"].timeout.emit()
	_check(not alert.visible and not monitoring.player_lingering_eye.visible, "The lingering eye eventually clears")
	monitoring.show_alert("04")
	monitoring.hide_timers["04"].timeout.emit()
	monitoring.dismiss_alert("04")
	_check(not alert.visible and not monitoring.player_toast.visible and not monitoring.player_lingering_eye.visible, "Explicit dismissal clears every part of a notification")
	room.leave_workstation()
	await create_timer(0.45).timeout
	observed.clear()
	workstation.editor.insert_text_at_caret("// Hidden editor update\n")
	await process_frame
	_check(not "typing" in observed, "A hidden workstation does not report programmatic editor changes as typing")

	var office: Node3D = room.get_node("Office")
	var notice := office.find_child("WorkplaceNotice", true, false) as MeshInstance3D
	var window := office.find_child("Window safety glass", true, false) as MeshInstance3D
	var nets := office.find_children("*net*", "MeshInstance3D", true, false)
	_check(notice != null and window != null and window.get_node_or_null("Solid") != null and not nets.is_empty(), "The office includes a physical notice and a solid window overlooking safety nets")
	if window != null:
		monitoring.last_priority_notice.clear()
		monitoring.last_context_notice.clear()
		room.inside_cubicle = true
		player.global_position = Vector3(5.4, 0.1, 0)
		await physics_frame
		room._observe_room(0.1)
		var absence_message: String = monitoring.player_message.text
		monitoring.last_priority_notice.clear()
		room.look_seconds["window_looked"] = 0.0
		player.global_position = Vector3(6.35, 0.02, -0.62)
		await physics_frame
		# Look down at the net itself, rather than aiming at the pane's center.
		camera.look_at(Vector3(9.5, -1.4, -3.4))
		room._observe_room(1.6)
		var window_message: String = monitoring.player_message.text
		monitoring.hide_timers["04"].timeout.emit()
		monitoring.eye_timers["04"].timeout.emit()
		# Simulate returning after the previous ordinary-action cooldown elapsed.
		monitoring.last_reactive_notice.clear()
		room.enter_workstation()
		await create_timer(0.45).timeout
		workstation.editor.insert_text_at_caret("// Returned from the window\n")
		await process_frame
		_check("absence" in absence_message.to_lower() and "window" in window_message.to_lower() and monitoring.player_toast.visible and monitoring.player_message.text == window_message, "Absence and downward window surveillance stay specific, and typing on return preserves the waiting window notice")
		room.leave_workstation()
		await create_timer(0.45).timeout
	else:
		_check(false, "Leaving the cubicle and studying the window trigger surveillance")
	if notice != null and room.has_method("_open_notice"):
		# Stand directly in front of the board and exercise the room's ray interaction.
		var surface_normal := notice.global_basis.y.normalized()
		player.global_position = notice.global_position + surface_normal * 1.6 - Vector3(0, camera.position.y, 0)
		camera.look_at(notice.global_position)
		await physics_frame
		room.interact()
		var notice_text := ""
		for label in room.notice_panel.find_children("*", "Label", true, false):
			notice_text += label.text + "\n"
		_check(room.notice_panel.visible and not player.active and not room.workstation_active and "three" in notice_text.to_lower() and "accidents" in notice_text.to_lower() and "net" in notice_text.to_lower(), "Looking at the board opens the notice about three engineers' accidents and net installation")
		room._close_notice()
		_check(not room.notice_panel.visible and player.active and not room.workstation_active, "Closing the notice restores walking without opening another computer")
	else:
		_check(false, "The workplace notice can be read in the room")
		_check(false, "Closing the notice restores room input")
	_finish(room)


func _finish(room: Node) -> void:
	room.queue_free()
	print("Surveillance integration: ", "PASS" if failures == 0 else "FAIL", " (", failures, " failures)")
	quit(0 if failures == 0 else 1)


func _check(condition: bool, description: String) -> bool:
	if condition:
		print("PASS: ", description)
	else:
		failures += 1
		printerr("FAIL: ", description)
	return condition
