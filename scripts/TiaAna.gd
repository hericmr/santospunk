extends Area2D

## Personagem Tia Ana - dona do bar
## Herda de InteractiveObject para funcionalidade completa

var dialogue_lines: Array[String] = [
	"Bem-vindo ao meu bar!",
	"O que você gostaria de beber?",
	"Essa é uma noite especial...",
	"Você parece perdido, quer uma dica?"
]

@export var look_description: String = "Uma mulher misteriosa com olhos penetrantes. Ela parece conhecer todos os segredos deste lugar."

# Propriedades do objeto
var object_name: String = "Tia Ana"
var description: String = "Uma mulher misteriosa com olhos penetrantes. Ela parece conhecer todos os segredos deste lugar."
var available_actions: Array[String] = []
var current_menu: Control = null

var current_dialogue_index: int = 0
var is_talking: bool = false
var is_hovered: bool = false

func _ready():
	# Configurar propriedades da personagem
	object_name = "Tia Ana"
	description = "Uma mulher misteriosa com olhos penetrantes. Ela parece conhecer todos os segredos deste lugar."
	
	# Definir ações específicas da Tia Ana
	available_actions = ["Falar", "Olhar", "Bater", "Chutar"]
	
	# Configurar funcionalidade interativa
	_setup_interactive_functionality()
	
	# Configurar área de colisão específica para a personagem
	_setup_collision_shape()

# Funcionalidade interativa
func _setup_interactive_functionality():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)

func _on_mouse_entered():
	is_hovered = true
	print("Mouse entrou em: ", object_name)
	# Aguardar um pouco antes de mostrar o menu para evitar flickering
	await get_tree().create_timer(0.2).timeout
	# Verificar se ainda está hoverando antes de mostrar o menu
	if is_hovered and not current_menu:
		_show_hover_menu()

func _on_mouse_exited():
	is_hovered = false
	print("Mouse saiu de: ", object_name)
	# Aguardar um pouco antes de esconder para evitar flickering
	await get_tree().create_timer(0.1).timeout
	# Verificar se ainda não está hoverando antes de esconder
	if not is_hovered:
		_hide_hover_menu()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_on_clicked(event.global_position)

func _on_clicked(click_position: Vector2):
	print("Clique em: ", object_name, " em ", click_position)

func _show_hover_menu():
	_hide_hover_menu()
	current_menu = _create_hover_menu()
	add_child(current_menu)
	
	var obj_pos = global_position
	var menu_offset = Vector2(100, -50)
	current_menu.global_position = obj_pos + menu_offset
	
	var viewport_size = get_viewport().get_visible_rect().size
	current_menu.global_position.x = clamp(current_menu.global_position.x, 0, viewport_size.x - current_menu.size.x)
	current_menu.global_position.y = clamp(current_menu.global_position.y, 0, viewport_size.y - current_menu.size.y)

func _hide_hover_menu():
	if current_menu:
		current_menu.queue_free()
		current_menu = null

func _is_mouse_over_object_or_menu() -> bool:
	var mouse_pos = get_global_mouse_position()
	
	# Verificar se o mouse está sobre o objeto
	var object_rect = Rect2(global_position, Vector2(100, 100))  # Ajustar tamanho conforme necessário
	if object_rect.has_point(mouse_pos):
		return true
	
	# Verificar se o mouse está sobre o menu
	if current_menu:
		var menu_rect = Rect2(current_menu.global_position, current_menu.size)
		if menu_rect.has_point(mouse_pos):
			return true
	
	return false

func _create_hover_menu() -> Control:
	var menu = Control.new()
	menu.name = "HoverMenu"
	menu.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Ignorar eventos de mouse para evitar interferência
	
	var background = ColorRect.new()
	background.color = Color(0.1, 0.1, 0.1, 0.95)
	background.size = Vector2(180, 140)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu.add_child(background)
	
	var button_container = VBoxContainer.new()
	button_container.position = Vector2(10, 10)
	button_container.size = Vector2(160, 120)
	menu.add_child(button_container)
	
	var title = Label.new()
	title.text = object_name
	title.add_theme_color_override("font_color", Color.CYAN)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button_container.add_child(title)
	
	var separator = HSeparator.new()
	button_container.add_child(separator)
	
	for action in available_actions:
		var button = Button.new()
		button.text = action
		button.custom_minimum_size = Vector2(140, 25)
		
		var style_normal = StyleBoxFlat.new()
		var style_hover = StyleBoxFlat.new()
		
		style_normal.bg_color = Color(0.3, 0.3, 0.3, 0.8)
		style_normal.corner_radius_top_left = 3
		style_normal.corner_radius_top_right = 3
		style_normal.corner_radius_bottom_left = 3
		style_normal.corner_radius_bottom_right = 3
		
		style_hover.bg_color = Color(0.5, 0.5, 0.5, 0.9)
		style_hover.corner_radius_top_left = 3
		style_hover.corner_radius_top_right = 3
		style_hover.corner_radius_bottom_left = 3
		style_hover.corner_radius_bottom_right = 3
		
		button.add_theme_stylebox_override("normal", style_normal)
		button.add_theme_stylebox_override("hover", style_hover)
		button.add_theme_color_override("font_color", Color.WHITE)
		
		button.pressed.connect(_on_action_button_pressed.bind(action))
		button_container.add_child(button)
	
	menu.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(menu, "modulate:a", 1.0, 0.3)
	
	return menu

func _on_action_button_pressed(action: String):
	print("Ação selecionada em ", object_name, ": ", action)
	on_action_performed(action, get_global_mouse_position())
	_hide_hover_menu()

# Sobrescrever métodos específicos da Tia Ana
func on_action_performed(action: String, _click_position: Vector2):
	match action:
		"Falar":
			_on_talk()
		"Olhar":
			_on_look()
		"Bater":
			_on_hit()
		"Chutar":
			_on_kick()
		_:
			print("Ação desconhecida: ", action)

func _setup_collision_shape():
	# Remover colisão padrão se existir
	if get_child_count() > 0 and get_child(0) is CollisionShape2D:
		get_child(0).queue_free()
	
	# Criar nova área de colisão baseada no tamanho da sprite
	var collision_shape = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	
	# Ajustar tamanho baseado na escala da sprite
	var sprite = get_node("tiana") as AnimatedSprite2D
	if sprite and sprite.sprite_frames:
		# Obter o tamanho do primeiro frame da animação
		var first_frame = sprite.sprite_frames.get_frame_texture("idle", 0)
		if first_frame:
			var sprite_size = first_frame.get_size()
			rect_shape.size = sprite_size * sprite.scale
			collision_shape.position = sprite.position
		else:
			# Tamanho padrão se não conseguir obter o frame
			rect_shape.size = Vector2(100, 100) * sprite.scale
	else:
		# Tamanho padrão se não encontrar a sprite
		rect_shape.size = Vector2(100, 100)
	
	collision_shape.shape = rect_shape
	add_child(collision_shape)


func _add_click_effect(_position: Vector2):
	# Criar efeito visual simples (pode ser melhorado com partículas)
	var effect = ColorRect.new()
	effect.color = Color.YELLOW
	effect.size = Vector2(20, 20)
	effect.position = _position - effect.size / 2
	get_tree().current_scene.add_child(effect)
	
	# Animar o efeito
	var tween = create_tween()
	tween.tween_property(effect, "modulate:a", 0.0, 0.5)
	tween.tween_callback(effect.queue_free)

## Sobrescrever métodos da classe pai

func _on_talk():
	if not is_talking:
		_start_dialogue()

func _start_dialogue():
	is_talking = true
	print("Iniciando diálogo com a Tia Ana...")
	
	# Usar o sistema de diálogo reutilizável
	DialogHelper.start_tia_ana_dialogue()
	
	# Conectar sinal para saber quando o diálogo terminar
	var dialog_box = DialogHelper.get_dialog_box()
	if dialog_box:
		dialog_box.dialog_ended.connect(_on_dialogue_ended.bind("Tia Ana"))

func _on_dialogue_ended(character_name: String):
	if character_name == "Tia Ana":
		is_talking = false
		print("Diálogo com a Tia Ana terminado.")

func _on_look():
	print("Você observa ", object_name, " cuidadosamente.")
	print(description)
	
	# Adicionar descrição mais detalhada baseada no contexto
	_add_detailed_description()

func _add_detailed_description():
	var detailed_descriptions = [
		"Ela parece estar sempre alerta, como se esperasse algo.",
		"Seus olhos brilham com uma sabedoria antiga.",
		"Há algo misterioso em seu sorriso.",
		"Ela move-se com a graça de quem conhece todos os cantos deste lugar."
	]
	
	var random_desc = detailed_descriptions[randi() % detailed_descriptions.size()]
	print(random_desc)

func _on_hit():
	print("Você tenta bater em ", object_name, "!")
	print("Tia Ana se afasta rapidamente, com uma expressão de desaprovação.")
	print("'Isso não é necessário, jovem!'")
	
	# Adicionar consequência (pode afetar reputação, etc.)
	_add_consequence("violence")

func _on_kick():
	print("Você tenta chutar ", object_name, "!")
	print("Tia Ana esquiva habilmente e olha para você com desprezo.")
	print("'Você deveria ter mais respeito!'")
	
	# Adicionar consequência
	_add_consequence("violence")

func _add_consequence(action_type: String):
	match action_type:
		"violence":
			print("Sua reputação com Tia Ana diminuiu.")
			# Aqui você pode implementar um sistema de reputação
		"rude":
			print("Tia Ana não está impressionada com sua atitude.")
		_:
			print("Sua ação teve consequências...")

## Métodos específicos da Tia Ana

func add_dialogue_line(line: String):
	dialogue_lines.append(line)

func set_dialogue_lines(lines: Array[String]):
	dialogue_lines = lines

func get_random_dialogue() -> String:
	if dialogue_lines.size() > 0:
		return dialogue_lines[randi() % dialogue_lines.size()]
	return "..."

func start_special_interaction():
	# Método para interações especiais da Tia Ana
	print("Tia Ana inicia uma conversa especial...")
	# Implementar lógica específica aqui
