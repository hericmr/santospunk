extends Area2D

@export var poster_texture: Texture2D
@export var face_texture: Texture2D
@export_multiline var dialog_text: String = ""

var _shown := false # legado, mantido para compatibilidade
var _player_inside := false
var _player_ref: Node2D = null
var _indicator_label: Label = null

func _ready():
	print("Poster ready")
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	_ensure_interact_action()

func _on_body_entered(body):
	print("Body entered poster area: ", body.name)
	if not body:
		return
	if body.name != "Player":
		return
	print("Player entered poster area")
	_player_inside = true
	_player_ref = body
	_show_indicator()

func _on_body_exited(body):
	print("Body exited poster area: ", body.name)
	if body and body == _player_ref:
		print("Player exited poster area")
		_player_inside = false
		_player_ref = null
		_hide_indicator()

func _process(_delta):
	if _player_inside:
		print("Player inside poster area, waiting for input")
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("ui_accept"):
			print("Interact pressed, showing dialog")
			_hide_indicator()
			_show_dialog()

func _show_dialog():
	print("Showing dialog")
	var dialog_scene: PackedScene = load("res://cenas/DialogOverlay.tscn")
	if dialog_scene == null:
		print("DialogOverlay.tscn not found")
		return
	var overlay = dialog_scene.instantiate()
	# Passa dados para o overlay
	if poster_texture:
		overlay.set("poster_texture", poster_texture)
	var face_tex: Texture2D = face_texture
	if face_tex == null:
		var maybe: Texture2D = load("res://artes/heric_rosto.png")
		if maybe != null:
			face_tex = maybe
	if face_tex:
		overlay.set("face_texture", face_tex)
	if dialog_text:
		overlay.set("dialog_text", dialog_text)
	get_tree().current_scene.add_child(overlay)

func _show_indicator():
	if _indicator_label == null and _player_ref:
		print("Showing poster indicator")
		_indicator_label = Label.new()
		_indicator_label.text = "!"
		_indicator_label.add_theme_color_override("font_color", Color(1, 1, 0))
		_indicator_label.add_theme_font_size_override("font_size", 52)
		_player_ref.add_child(_indicator_label)
		_indicator_label.position = Vector2(0, -140)

func _hide_indicator():
	if _indicator_label and is_instance_valid(_indicator_label):
		print("Hiding poster indicator")
		_indicator_label.queue_free()
		_indicator_label = null

func _ensure_interact_action():
	if not InputMap.has_action("interact"):
		InputMap.add_action("interact")
	if InputMap.action_get_events("interact").is_empty():
		var ev_e = InputEventKey.new(); ev_e.keycode = KEY_E; InputMap.action_add_event("interact", ev_e)
