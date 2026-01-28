extends CharacterBody3D

const MAX_SPEED: float = 9.0
const ACCEL: float = 3.5
const DEACCEL: float = 16.0

var dir: Vector3 = Vector3.ZERO
var mouse_sensitivity: float = 0.05

# nodes
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var rotation_helper: Node3D = $CameraPivot
@onready var flashlight: SpotLight3D = $CameraPivot/SpotLight3D
@onready var footsteps: AudioStreamPlayer3D = $Footsteps
@onready var flashlight_click: AudioStreamPlayer3D = $FlashlightClick

@onready var jumpscare_image: TextureRect = $JumpscareUI/TextureRect

@onready var win_image: TextureRect = $WinUI/TextureRect



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	flashlight.visible = false
	jumpscare_image.visible = false
	win_image.visible = false  


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

	var is_moving := Vector2(velocity.x, velocity.z).length() > 0.2

	if is_moving:
		if not footsteps.playing:
			footsteps.play()
	else:
		if footsteps.playing:
			footsteps.stop()


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))

		var rot = rotation_helper.rotation_degrees
		rot.x = clamp(rot.x, -70.0, 70.0)
		rotation_helper.rotation_degrees = rot

	if event.is_action_pressed("toggle_flashlight"):
		flashlight.visible = !flashlight.visible
		flashlight_click.play()

	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(
			Input.MOUSE_MODE_VISIBLE
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
			else Input.MOUSE_MODE_CAPTURED
		)


func start_jumpscare():
	jumpscare_image.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()


func _on_WinTrigger_body_entered(body):
	if body == self:
		start_win_sequence()


func start_win_sequence():
	win_image.visible = true
	
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	velocity = Vector3.ZERO
	
	await get_tree().create_timer(3.0).timeout
	
	win_image.visible = false
	
	get_tree().reload_current_scene() 


func _on_win_trigger_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
