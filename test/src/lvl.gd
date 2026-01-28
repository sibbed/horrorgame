extends Node3D

func _ready():
	var monster = get_tree().get_first_node_in_group("monster")
	var player = get_tree().get_first_node_in_group("player")

	if monster and player:
		monster.set_target(player)


func _on_win_trigger_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
