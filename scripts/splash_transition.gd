extends TextureRect

func _ready():
	var timer = Timer.new()
	timer.set_wait_time(4.0)
	timer.set_one_shot(true)
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://cenas/Game.tscn")
