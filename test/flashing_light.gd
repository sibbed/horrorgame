extends SpotLight3D  

var timer: Timer

func _ready():
	randomize()
	timer = Timer.new()
	timer.wait_time = randf_range(0.05, 0.1)
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(on_timer_timeout)  # Godot 4 uses the new signal connection style

func on_timer_timeout():
	timer.wait_time = randf_range(0.05, 0.1)
	light_energy = randf_range(0.0, 1.0)
