extends KinematicBody2D

# --- Constantes ---
const SPEED = 250.0
const JUMP_FORCE = -500.0
const DOUBLE_JUMP_FORCE = -250.0
const UP_DIRECTION = Vector2.UP

# --- Variáveis ---
# Gravidade (pode usar a do projeto ou um valor fixo)
var gravity = 980  # aproximadamente 9,8 * 100 pixels/s²

var velocity = Vector2()
var can_double_jump = true

# Nó de animação no Godot 3 é AnimatedSprite
onready var animated_sprite = $AnimatedSprite


func _ready():
	# Garante que as ações existam (fallback quando projeto não tem Input Map configurado)
	var actions = ["move_left", "move_right", "jump", "attack", "attack2"]
	for action in actions:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
	# Binds padrão (A/D, setas, Espaço, J/K)
	if InputMap.get_action_list("move_left").empty():
		var ev_left = InputEventKey.new(); ev_left.scancode = KEY_LEFT; InputMap.action_add_event("move_left", ev_left)
		var ev_a = InputEventKey.new(); ev_a.scancode = KEY_A; InputMap.action_add_event("move_left", ev_a)
	if InputMap.get_action_list("move_right").empty():
		var ev_right = InputEventKey.new(); ev_right.scancode = KEY_RIGHT; InputMap.action_add_event("move_right", ev_right)
		var ev_d = InputEventKey.new(); ev_d.scancode = KEY_D; InputMap.action_add_event("move_right", ev_d)
	if InputMap.get_action_list("jump").empty():
		var ev_space = InputEventKey.new(); ev_space.scancode = KEY_SPACE; InputMap.action_add_event("jump", ev_space)
	if InputMap.get_action_list("attack").empty():
		var ev_j = InputEventKey.new(); ev_j.scancode = KEY_J; InputMap.action_add_event("attack", ev_j)
	if InputMap.get_action_list("attack2").empty():
		var ev_k = InputEventKey.new(); ev_k.scancode = KEY_K; InputMap.action_add_event("attack2", ev_k)

	# Animação inicial
	if animated_sprite:
		animated_sprite.play("idle")


func _physics_process(delta):
	# Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_double_jump = true

	# Movimento horizontal (Godot 3 não tem Input.get_axis)
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if direction != 0:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0
	else:
		# Desaceleração suave
		velocity.x = lerp(velocity.x, 0, 0.2)

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

	# Aplicar movimento
	velocity = move_and_slide(velocity, UP_DIRECTION)
