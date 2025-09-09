extends CharacterBody2D

# --- Constantes ---
const SPEED = 350.0
const JUMP_FORCE = -300.0
const DOUBLE_JUMP_FORCE = -300.0
const UP_DIRECTION = Vector2.UP

# --- Variáveis ---
# Gravidade (pode usar a do projeto ou um valor fixo)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_double_jump = true

# Nó de animação no Godot 3 é AnimatedSprite
@onready var animated_sprite = $AnimatedSprite
@onready var sprite_frames = animated_sprite.sprite_frames if animated_sprite else null


func _ready():
	# Adicionar o jogador ao grupo "player" para detecção de transição
	add_to_group("player")
	
	_setup_input_actions()
	_play_if_exists("idle")
	if _is_touch():
		_create_mobile_controls()

func _setup_input_actions():
	var actions = ["move_left", "move_right", "jump", "doublejump", "attack", "attack2"]
	for action in actions:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
	if InputMap.action_get_events("move_left").is_empty():
		var ev_left = InputEventKey.new(); ev_left.keycode = KEY_LEFT; InputMap.action_add_event("move_left", ev_left)
		var ev_a = InputEventKey.new(); ev_a.keycode = KEY_A; InputMap.action_add_event("move_left", ev_a)
	if InputMap.action_get_events("move_right").is_empty():
		var ev_right = InputEventKey.new(); ev_right.keycode = KEY_RIGHT; InputMap.action_add_event("move_right", ev_right)
		var ev_d = InputEventKey.new(); ev_d.keycode = KEY_D; InputMap.action_add_event("move_right", ev_d)
	if InputMap.action_get_events("jump").is_empty():
		var ev_space = InputEventKey.new(); ev_space.keycode = KEY_SPACE; InputMap.action_add_event("jump", ev_space)
	if InputMap.action_get_events("attack").is_empty():
		var ev_j = InputEventKey.new(); ev_j.keycode = KEY_J; InputMap.action_add_event("attack", ev_j)
	if InputMap.action_get_events("attack2").is_empty():
		var ev_k = InputEventKey.new(); ev_k.keycode = KEY_K; InputMap.action_add_event("attack2", ev_k)


func _physics_process(delta):
	_apply_gravity(delta)
	_handle_move()
	_handle_jump()
	_handle_attacks()
	_update_animations()
	move_and_slide()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_double_jump = true

func _handle_move():
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * SPEED
		if animated_sprite:
			animated_sprite.flip_h = direction < 0
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.2)

func _handle_jump():
	if not Input.is_action_just_pressed("jump"):
		return
	if is_on_floor():
		velocity.y = JUMP_FORCE
		_play_if_exists("jump")
		return
	if can_double_jump and not is_on_floor():
		velocity.y = DOUBLE_JUMP_FORCE
		can_double_jump = false
		if _has_anim("doublejump"):
			_play_if_exists("doublejump")
		else:
			_play_if_exists("jump")

func _handle_attacks():
	if Input.is_action_just_pressed("attack"):
		_play_if_exists("attack")
		return
	if Input.is_action_just_pressed("attack2"):
		_play_if_exists("attack2")

func _update_animations():
	if not animated_sprite or (animated_sprite.animation and animated_sprite.animation.begins_with("attack")):
		return
	if not is_on_floor():
		if velocity.y < 0:
			if not can_double_jump and _has_anim("doublejump"):
				_play_if_exists("doublejump")
			else:
				_play_if_exists("jump")
			return
		# Caindo
		if _has_anim("fall"):
			_play_if_exists("fall")
		else:
			_play_if_exists("idle")
		return
	# Chão
	if abs(velocity.x) > 90:
		_play_if_exists("run")
	else:
		_play_if_exists("idle")

func _has_anim(anim_name):
	return animated_sprite and sprite_frames and anim_name in sprite_frames.get_animation_names()

func _play_if_exists(anim_name):
	if _has_anim(anim_name):
		animated_sprite.play(anim_name)

# --- Mobile controls ---
func _is_touch():
	# Godot 4
	return DisplayServer.is_touchscreen_available()

func _create_mobile_controls():
	var layer = CanvasLayer.new()
	layer.name = "MobileUI"
	get_tree().current_scene.add_child(layer)

	var ui_root = Control.new()
	ui_root.name = "ControlsRoot"
	ui_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_root.anchor_left = 0
	ui_root.anchor_top = 0
	ui_root.anchor_right = 1
	ui_root.anchor_bottom = 1
	layer.add_child(ui_root)

	# Left/Right group (bottom-left)
	var left_btn = _make_action_button("←", "move_left")
	left_btn.anchor_left = 0
	left_btn.anchor_bottom = 1
	left_btn.position = Vector2(40, -100)
	ui_root.add_child(left_btn)

	var right_btn = _make_action_button("→", "move_right")
	right_btn.anchor_left = 0
	right_btn.anchor_bottom = 1
	right_btn.position = Vector2(140, -100)
	ui_root.add_child(right_btn)

	# Jump (bottom-right)
	var jump_btn = _make_action_button("⭡", "jump")
	jump_btn.anchor_right = 1
	jump_btn.anchor_bottom = 1
	jump_btn.position = Vector2(-140, -110)
	ui_root.add_child(jump_btn)

	# Attack buttons (above jump)
	var atk_btn = _make_action_button("J", "attack")
	atk_btn.anchor_right = 1
	atk_btn.anchor_bottom = 1
	atk_btn.position = Vector2(-240, -170)
	ui_root.add_child(atk_btn)

	var atk2_btn = _make_action_button("K", "attack2")
	atk2_btn.anchor_right = 1
	atk2_btn.anchor_bottom = 1
	atk2_btn.position = Vector2(-60, -190)
	ui_root.add_child(atk2_btn)

func _make_action_button(label_text, action_name):
	var btn = Button.new()
	btn.text = label_text
	btn.custom_minimum_size = Vector2(90, 90)
	btn.focus_mode = Control.FOCUS_NONE
	btn.mouse_filter = Control.MOUSE_FILTER_PASS
	btn.modulate = Color(1, 1, 1, 0.75)
	btn.connect("button_down", Callable(self, "_on_btn_down").bind(action_name))
	btn.connect("button_up", Callable(self, "_on_btn_up").bind(action_name))
	return btn

func _on_btn_down(action_name):
	Input.action_press(action_name)

func _on_btn_up(action_name):
	Input.action_release(action_name)
