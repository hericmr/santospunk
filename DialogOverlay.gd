extends CanvasLayer

@export var poster_texture: Texture2D
@export var face_texture: Texture2D
@export_multiline var dialog_text: String = ""

@onready var poster_rect: TextureRect = get_node_or_null("Root/PosterOutside")
@onready var face_rect: TextureRect = get_node_or_null("Root/Face")
@onready var text_label: RichTextLabel = get_node_or_null("Root/Panel/HBox/VBox/Text")
@onready var close_btn: Button = get_node_or_null("Root/Panel/HBox/VBox/Close")

func _ready():
	if poster_texture and poster_rect:
		poster_rect.texture = poster_texture
	if face_texture and face_rect:
		face_rect.texture = face_texture
	if dialog_text and text_label:
		text_label.text = dialog_text

	if close_btn:
		close_btn.pressed.connect(_on_close)

	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_close():
	get_tree().paused = false
	queue_free()
