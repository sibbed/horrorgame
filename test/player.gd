extends CharacterBody3D

const MAX_SPEED: float = 9.0
const ACCEL: float = 3.5
const DEACCEL: float = 16.0

var dir: Vector3 = Vector3.ZERO
var mouse_sensitivity: float = 0.05

@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var rotation_helper: Node3D = $CameraPivot


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	process_movement(delta)


	dir = Vector3.ZERO

	var input_vector := Vector2.ZERO

	if Input.is_action_pressed("movement_forward"):
		input_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_vector.x += 1

	input_vector = input_vector.normalized()

	var cam_basis = camera.global_transform.basis

	dir += -cam_basis.z * input_vector.y
	dir += cam_basis.x * input_vector.x

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(
			Input.MOUSE_MODE_VISIBLE
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
			else Input.MOUSE_MODE_CAPTURED
		)


func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()


	var hvel = velocity
	hvel.y = 0

	var target = dir * MAX_SPEED

	var accel = ACCEL if dir.dot(hvel) > 0 else DEACCEL
	hvel = hvel.lerp(target, accel * delta)

	velocity.x = hvel.x
	velocity.z = hvel.z

	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(
			deg_to_rad(-event.relative.y * mouse_sensitivity)
		)
		rotate_y(
			deg_to_rad(-event.relative.x * mouse_sensitivity)
		)

		var rot = rotation_helper.rotation_degrees
		rot.x = clamp(rot.x, -70.0, 70.0)
		rotation_helper.rotation_degrees = rot
