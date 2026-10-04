extends CharacterBody3D

const WALK_SPEED := 2.8
const GROUND_ACCELERATION := 28.0
const GROUND_FRICTION := 8.0
const STOP_SPEED := 1.0
const AIR_ACCELERATION := 3.0
const MAX_SPEED := 8.0
const GRAVITY := 12.0
const JUMP_SPEED := 4.2
const JUMP_BUFFER_TIME := 0.12
const MOUSE_SENSITIVITY := 0.002

var active := true:
	set(value):
		active = value
		if not active:
			velocity = Vector3.ZERO
			_jump_buffer_remaining = 0.0
			_jump_held = false
var _jump_buffer_remaining := 0.0
var _jump_held := false
@onready var camera: Camera3D = $Camera3D

func _input(event: InputEvent) -> void:
	if not active or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventKey and event.physical_keycode == KEY_SPACE and not event.echo:
		_jump_held = event.pressed
		if event.pressed:
			_jump_buffer_remaining = JUMP_BUFFER_TIME
	if event is InputEventMouseMotion:
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
	_jump_buffer_remaining = maxf(_jump_buffer_remaining - delta, 0.0)
	var jumping := active and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and is_on_floor() and (_jump_buffer_remaining > 0.0 or _jump_held)
	if jumping:
		_jump_buffer_remaining = 0.0
		velocity.y = JUMP_SPEED
	var grounded := is_on_floor() and not jumping
	var horizontal := Vector3(velocity.x, 0.0, velocity.z)
	var speed := horizontal.length()
	if grounded and speed > 0.0:
		horizontal *= maxf(speed - maxf(speed, STOP_SPEED) * GROUND_FRICTION * delta, 0.0) / speed
	var available := WALK_SPEED - horizontal.dot(direction)
	if available > 0.0:
		var acceleration := GROUND_ACCELERATION if grounded else AIR_ACCELERATION
		horizontal += direction * minf(acceleration * delta, available)
	horizontal = horizontal.limit_length(MAX_SPEED)
	velocity.x = horizontal.x
	velocity.z = horizontal.z
	if not grounded:
		velocity.y -= GRAVITY * delta
	move_and_slide()
