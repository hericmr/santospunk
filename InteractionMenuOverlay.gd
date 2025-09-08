extends CanvasLayer

class_name InteractionMenuOverlay

@export var title: String = ""
@export var default_portrait: Texture2D
@export var options: Array = [] # [{icon: String, label: String, on_select: Callable, portrait: Texture2D}]

@onready var title_label: Label = $Root/Border/Panel/Title
@onready var portrait_rect: TextureRect = $Root/Border/Panel/Content/Portrait
@onready var buttons_box: HBoxContainer = $Root/Border/Panel/Content/Center/Buttons

var is_active := false
var selected_index := 0

func _ready():
	is_active = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	_update_title()
	_update_portrait(default_portrait)
	_create_buttons()
	_update_selection_visual()

func _unhandled_input(event):
	if not is_active:
		return
	if event.is_action_pressed("ui_left"):
		_move_left()
	elif event.is_action_pressed("ui_right"):
		_move_right()
	elif event.is_action_pressed("ui_accept"):
		_select()
	elif event.is_action_pressed("ui_cancel"):
		_close()

func _move_left():
	selected_index = (selected_index - 1 + options.size()) % max(options.size(), 1)
	_update_selection_visual()

func _move_right():
	selected_index = (selected_index + 1) % max(options.size(), 1)
	_update_selection_visual()

func _select():
	if options.is_empty():
		return
	var opt = options[selected_index]
	if typeof(opt) == TYPE_DICTIONARY and opt.has("on_select") and opt.on_select is Callable and opt.on_select.is_valid():
		opt.on_select.call()

func _close():
	is_active = false
	get_tree().paused = false
	queue_free()

func _update_title():
	title_label.text = title

func _update_portrait(tex: Texture2D):
	if tex:
		portrait_rect.texture = tex

func _create_buttons():
	buttons_box.queue_free_children()
	for idx in options.size():
		var opt = options[idx]
		var btn = Button.new()
		btn.toggle_mode = true
		btn.text = opt.get("icon", "?")
		btn.tooltip_text = opt.get("label", "")
		btn.focus_mode = Control.FOCUS_NONE
		btn.pressed.connect(Callable(self, "_on_btn_pressed").bind(idx))
		buttons_box.add_child(btn)

func _on_btn_pressed(idx: int):
	selected_index = idx
	_update_selection_visual()
	_select()

func _update_selection_visual():
	for i in buttons_box.get_child_count():
		var b: Button = buttons_box.get_child(i)
		b.button_pressed = i == selected_index
		# Atualiza retrato se houver um específico
		var opt = options[i]
		var portrait_tex: Texture2D = opt.get("portrait") if typeof(opt) == TYPE_DICTIONARY and opt.has("portrait") else default_portrait
		_update_portrait(portrait_tex)
