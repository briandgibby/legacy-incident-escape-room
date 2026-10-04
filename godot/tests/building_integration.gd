extends SceneTree

const WALK_SPEED := 2.8
const TEST_TIME_SCALE := 8.0

var failures := 0
var visual_review_directory := ""


func _initialize() -> void:
	# Keep the workstation's disposable incident copy separate from player saves.
	ProjectSettings.set_setting("application/config/use_custom_user_dir", true)
	ProjectSettings.set_setting("application/config/custom_user_dir_name", "RifkinBuildingTests")
	# Optional rendered review: -- --visual-review=C:/absolute/path/outside/the/repository
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--visual-review="):
			visual_review_directory = argument.trim_prefix("--visual-review=")
	_run.call_deferred()


func _run() -> void:
	var scene: PackedScene = load("res://office.tscn")
	var room = scene.instantiate()
	root.add_child(room)
	await physics_frame
	await physics_frame
	var player: CharacterBody3D = room.get_node("Player")
	var camera: Camera3D = player.get_node("Camera3D")
	var office: Node3D = room.get_node("Office")
	if not visual_review_directory.is_empty():
		if not _check(visual_review_directory.is_absolute_path() and DirAccess.make_dir_recursive_absolute(visual_review_directory) == OK, "The visual review output directory is available"):
			_finish(room)
			return
	# Script the existing capsule at walking speed, without competing keyboard physics.
	player.set_physics_process(false)
	Engine.time_scale = TEST_TIME_SCALE
	await _capture_view(camera, Vector3(-2.6, 1.168, 1.637), "00-preserved-office.png")
	for waypoint in [Vector3(-2.72, 0, 4.15), Vector3(3.5, 0, 4.15), Vector3(3.5, 0, -6.3), Vector3(5.15, 0, -6.3)]:
		if not await _walk_to(player, waypoint, "The office path reaches the service door around the cubicles and cabinets"):
			_finish(room)
			return

	var leaf := office.find_child("Service door leaf", true, false) as MeshInstance3D
	if not _check(leaf != null, "The service door retains its existing physical leaf"):
		_finish(room)
		return
	await _walk_for(player, Vector3(0, 0, -1), 0.7)
	_check(player.global_position.z > -6.7 and player.is_on_floor(), "The closed service door blocks the player's capsule")
	# Exercise the same raycast interaction used by E, aimed at the actual leaf.
	camera.look_at(leaf.to_global(leaf.get_aabb().get_center()))
	await _capture_view(camera, leaf.to_global(leaf.get_aabb().get_center()), "00a-staff-door.png")
	room.interact()
	await create_timer(0.4).timeout
	if not await _walk_to(player, Vector3(5.15, 0, -8.4), "Using the service door opens a supported passage through the office wall"):
		_finish(room)
		return
	await _capture_view(camera, Vector3(5.15, 1.4, -13.3), "01-upper-lobby.png")
	await _capture_view(camera, Vector3(3.39, 2.66, -9.625), "01a-break-room-entry.png")

	for waypoint in [Vector3(5.15, 0, -9.5), Vector3(1.8, 0, -9.5)]:
		if not await _walk_to(player, waypoint, "The player can walk from the lobby into the break room"):
			_finish(room)
			return
	await _capture_view(camera, Vector3(-1, 1.2, -10.3), "02-break-room.png")
	for waypoint in [Vector3(5.15, 0, -9.5), Vector3(5.15, 0, -14.5)]:
		if not await _walk_to(player, waypoint, "The player can walk from the break room into the upper elevator cab"):
			_finish(room)
			return
	var upper_control := office.find_child("Elevator upper control", true, false) as MeshInstance3D
	var lower_control := office.find_child("Elevator lower control", true, false) as MeshInstance3D
	if not _check(upper_control != null and lower_control != null, "Both elevator cabs have reachable physical controls"):
		_finish(room)
		return
	await _capture_view(camera, upper_control.to_global(upper_control.get_aabb().get_center()), "03-upper-cab-control.png")
	if not await _ride_elevator(room, player, camera, upper_control, -6.0, "The upper elevator control descends to the lower cab"):
		_finish(room)
		return
	_check(camera.far >= 54.0, "The camera range covers the long corridor's exit sightline")
	if not await _walk_to(player, Vector3(5.15, -6, -10), "The lower cab opens onto a supported landing"):
		_finish(room)
		return
	await _capture_view(camera, Vector3(-48.7, -4.6, -10), "04-lower-corridor.png")
	if not await _walk_to(player, Vector3(-45.5, -6, -10), "The full exit corridor supports the walking capsule"):
		_finish(room)
		return
	await _capture_view(camera, Vector3(-48.7, -4.65, -10), "05-physical-exit.png")
	if not await _walk_to(player, Vector3(-48.0, -6, -10), "The player can approach the recognizable exit"):
		_finish(room)
		return
	await _walk_for(player, Vector3.LEFT, 0.7)
	_check(player.global_position.x > -48.7 and player.is_on_floor(), "The physical exit stops departure without ending the shift")
	for waypoint in [Vector3(5.15, -6, -10), Vector3(5.15, -6, -14.5)]:
		if not await _walk_to(player, waypoint, "The player can return from the exit to the lower elevator cab"):
			_finish(room)
			return
	if not await _ride_elevator(room, player, camera, lower_control, 0.0, "The lower elevator control returns to the upper cab"):
		_finish(room)
		return
	for waypoint in [Vector3(5.15, 0, -8.4), Vector3(5.15, 0, -6.3), Vector3(3.5, 0, -6.3), Vector3(3.5, 0, 4.15), Vector3(-2.72, 0, 4.15), Vector3(-2.72, 0, 3.33)]:
		if not await _walk_to(player, waypoint, "The complete return path reaches the original workstation"):
			_finish(room)
			return
	camera.look_at(Vector3(-2.6, 1.168, 1.637))
	room.interact()
	await create_timer(0.45).timeout
	_check(room.workstation_active and room.get_node("CanvasLayer/Workstation").visible, "The original workstation still opens after the building round trip")
	await _capture_view(camera, Vector3(-2.6, 1.168, 1.637), "06-return-terminal.png")
	_finish(room)


func _walk_to(player: CharacterBody3D, target: Vector3, description: String) -> bool:
	var delta := TEST_TIME_SCALE / float(Engine.physics_ticks_per_second)
	var remaining := Vector3(target.x - player.global_position.x, 0, target.z - player.global_position.z)
	var steps := int(ceil((remaining.length() / WALK_SPEED + 1.0) / delta))
	var supported := true
	for step in range(steps):
		await physics_frame
		remaining = Vector3(target.x - player.global_position.x, 0, target.z - player.global_position.z)
		if remaining.length() <= 0.04:
			break
		var direction := remaining.normalized()
		var speed := minf(WALK_SPEED, remaining.length() / delta)
		player.velocity.x = direction.x * speed
		player.velocity.z = direction.z * speed
		player.velocity.y = -0.3 if player.is_on_floor() else player.velocity.y - 12.0 * delta
		player.move_and_slide()
		supported = supported and player.is_on_floor()
	player.velocity = Vector3.ZERO
	remaining = Vector3(target.x - player.global_position.x, 0, target.z - player.global_position.z)
	var reached := remaining.length() <= 0.06 and supported and absf(player.global_position.y - target.y) < 0.06
	if not reached:
		printerr("Stopped at ", player.global_position, "; expected supported waypoint ", target)
	return _check(reached, description)


func _walk_for(player: CharacterBody3D, direction: Vector3, seconds: float) -> void:
	var delta := TEST_TIME_SCALE / float(Engine.physics_ticks_per_second)
	for step in range(int(ceil(seconds / delta))):
		await physics_frame
		player.velocity.x = direction.x * WALK_SPEED
		player.velocity.z = direction.z * WALK_SPEED
		player.velocity.y = -0.3 if player.is_on_floor() else player.velocity.y - 12.0 * delta
		player.move_and_slide()
	player.velocity = Vector3.ZERO


func _ride_elevator(room: Node, player: CharacterBody3D, camera: Camera3D, control: MeshInstance3D, floor_height: float, description: String) -> bool:
	camera.look_at(control.to_global(control.get_aabb().get_center()))
	var horizontal_position := Vector2(player.global_position.x, player.global_position.z)
	var view := camera.global_basis
	room.interact()
	_check(not player.active, "Elevator travel temporarily disables walking")
	await create_timer(1.2).timeout
	var arrived: bool = absf(player.global_position.y - floor_height) < 0.06 and player.active
	_check(Vector2(player.global_position.x, player.global_position.z).is_equal_approx(horizontal_position) and camera.global_basis.is_equal_approx(view) and player.velocity.is_zero_approx(), "Elevator travel preserves the player's position within the cab and view, and clears movement")
	return _check(arrived, description)


func _capture_view(camera: Camera3D, target: Vector3, filename: String) -> void:
	if visual_review_directory.is_empty():
		return
	var walking_view := camera.transform
	camera.look_at(target)
	await process_frame
	await RenderingServer.frame_post_draw
	var path := visual_review_directory.path_join(filename)
	_check(root.get_texture().get_image().save_png(path) == OK, "Visual capture: " + path)
	camera.transform = walking_view


func _finish(room: Node) -> void:
	Engine.time_scale = 1.0
	room.queue_free()
	print("Building integration: ", "PASS" if failures == 0 else "FAIL", " (", failures, " failures)")
	quit(0 if failures == 0 else 1)


func _check(condition: bool, description: String) -> bool:
	if condition:
		print("PASS: ", description)
	else:
		failures += 1
		printerr("FAIL: ", description)
	return condition
