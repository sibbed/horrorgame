extends CharacterBody3D

@export var speed := 4.0
@export var turn_speed := 5.0
@export var stop_distance := 1.5
@export var contact_distance := 2.0  

var target: Node3D = null

func _ready():
	target = get_tree().get_first_node_in_group("player")
	if target == null:
		target = get_parent().get_node("Player") if get_parent().has_node("Player") else null

func _physics_process(delta):
	if target == null:
		return

	var dir = target.global_position - global_position
	dir.y = 0
	var dist = dir.length()

	# Contact check
	if dist <= contact_distance:
		print("Get touched")  
		velocity = Vector3.ZERO
		return

	if dist < stop_distance:
		velocity = Vector3.ZERO
		return

	dir = dir.normalized()

	var target_rot = atan2(dir.x, dir.z)
	rotation.y = lerp_angle(rotation.y, target_rot, turn_speed * delta)

	velocity = velocity.lerp(dir * speed, 5 * delta)
	move_and_slide()
