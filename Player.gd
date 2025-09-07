extends CharacterBody2D

# --- Constantes ---
const SPEED = 250.0
const JUMP_FORCE = -500.0
const DOUBLE_JUMP_FORCE = -250.0
const UP_DIRECTION = Vector2.UP

# --- Variáveis ---
# Gravidade (pode usar a do projeto ou um valor fixo)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_double_jump = true

# Nó de animação no Godot 3 é AnimatedSprite
@onready var animated_sprite = $AnimatedSprite


func _ready():
	# Garante que as ações existam (fallback quando projeto não tem Input Map configurado)
	var actions = ["move_left", "move_right", "jump", "attack", "attack2"]
	for action in actions:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
	# Binds padrão (A/D, setas, Espaço, J/K)
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

	# Animação inicial
	if animated_sprite:
		animated_sprite.play("idle")


func _physics_process(delta):
	# Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_double_jump = true

	# Movimento horizontal (Godot 4 tem Input.get_axis)
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0
	else:
		# Desaceleração suave
		velocity.x = lerp(velocity.x, 0.0, 0.2)

	# Pulo simples (sem pulo duplo temporariamente)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_FORCE

	# Ataques
	if Input.is_action_just_pressed("attack"):
		animated_sprite.play("attack")
	elif Input.is_action_just_pressed("attack2"):
		animated_sprite.play("attack2")

	# Atualizar animações básicas quando não está atacando
	if not animated_sprite.animation.begins_with("attack"):
		if not is_on_floor():
			# No ar - usar animação de queda se existir, senão manter idle
			if "fall" in animated_sprite.frames.get_animation_names():
				animated_sprite.play("fall")
			else:
				animated_sprite.play("idle")
		elif abs(velocity.x) > 90:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")

	# Aplicar movimento (Godot 4 usa move_and_slide() sem parâmetros)
	move_and_slide()
