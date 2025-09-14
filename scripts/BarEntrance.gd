extends Area2D

var _player_inside := false
var _player_ref: Node2D = null
var _indicator_label: Label = null

func _ready():
	print("BarEntrance ready")
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	print("Body entered: ", body.name)
	if not body:
		return
	if body.name != "Player": # Using name check as per user's example
		return
	print("Player entered bar entrance area")
	_player_inside = true
	_player_ref = body
	_show_indicator()

func _on_body_exited(body):
	print("Body exited: ", body.name)
	if body and body == _player_ref:
		print("Player exited bar entrance area")
		_player_inside = false
		_player_ref = null
		_hide_indicator()

func _process(_delta):
	if _player_inside:
		print("Player inside, waiting for input")
		if Input.is_action_just_pressed("ui_accept"):
			print("Space pressed, changing scene to bar_da_tia_ana.tscn")
			get_tree().change_scene_to_file("res://cenas/bar_da_tia_ana.tscn")

func _show_indicator():
	if _indicator_label == null and _player_ref:
		print("Showing indicator")
		_indicator_label = Label.new()
		_indicator_label.text = "!"
		_indicator_label.add_theme_color_override("font_color", Color(1, 1, 0))
		_indicator_label.add_theme_font_size_override("font_size", 52)
		_player_ref.add_child(_indicator_label)
		_indicator_label.position = Vector2(0, -140)

func _hide_indicator():
	if _indicator_label and is_instance_valid(_indicator_label):
		print("Hiding indicator")
		_indicator_label.queue_free()
		_indicator_label = null
