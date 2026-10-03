extends CharacterBody3D

const WALK_SPEED := 2.8
const MOUSE_SENSITIVITY := 0.002

var active := true
@onready var camera: Camera3D = $Camera3D

func _input(event: InputEvent) -> void:
	if active and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotation.x = clampf(camera.rotation.x - event.relative.y * MOUSE_SENSITIVITY, -1.4, 1.4)

func _physics_process(delta: float) -> void:
	var direction := Vector3.ZERO
	if active and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var movement := Vector2(
			float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A)),
			float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W))
		)
		direction = (transform.basis * Vector3(movement.x, 0.0, movement.y)).normalized()
	velocity.x = move_toward(velocity.x, direction.x * WALK_SPEED, 16.0 * delta)
	velocity.z = move_toward(velocity.z, direction.z * WALK_SPEED, 16.0 * delta)
	if not is_on_floor():
		velocity.y -= 12.0 * delta
	move_and_slide()
