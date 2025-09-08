extends CanvasLayer

@export var poster_texture: Texture2D
@export var face_texture: Texture2D
@export_multiline var dialog_text: String = ""
@export var chars_per_second: float = 30.0

@onready var poster_rect: TextureRect = get_node_or_null("Root/PosterOutside")
@onready var face_rect: TextureRect = get_node_or_null("Root/Face")
@onready var text_label: RichTextLabel = get_node_or_null("Root/Panel/HBox/VBox/Text")
@onready var close_btn: Button = get_node_or_null("Root/Panel/HBox/VBox/Close")

var _full_text: String = ""
var _char_index: int = 0
var _accum: float = 0.0
var _is_typing: bool = false

func _ready():
	if poster_texture and poster_rect:
		poster_rect.texture = poster_texture
	if face_texture and face_rect:
		face_rect.texture = face_texture
	if dialog_text and text_label:
		_start_typing(dialog_text)

	if close_btn:
		close_btn.pressed.connect(_on_close)

	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	if _is_typing and text_label:
		_accum += delta * max(chars_per_second, 1.0)
		while _accum >= 1.0 and _char_index < _full_text.length():
			text_label.text += _full_text[_char_index]
			_char_index += 1
			_accum -= 1.0
		if _char_index >= _full_text.length():
			_is_typing = false

func _unhandled_input(event):
	if _is_typing and event.is_action_pressed("ui_accept") and text_label:
		text_label.text = _full_text
		_is_typing = false

func _start_typing(text: String):
	_full_text = text
	_char_index = 0
	_accum = 0.0
	_is_typing = true
	text_label.text = ""

func _on_close():
	get_tree().paused = false
	queue_free()
