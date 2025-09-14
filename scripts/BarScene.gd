class_name BarScene
extends Node2D

## Script principal da cena do bar
## Gerencia o sistema de point-and-click e interações

@export var click_detector_scene: PackedScene
@export var enable_debug_mode: bool = true

var click_detector: Node
var interactable_objects: Array[Node] = []

func _ready():
	# Configurar sistema de point-and-click
	_setup_point_and_click_system()
	
	# Registrar objetos interativos
	_register_interactable_objects()
	
	# Configurar câmera
	_setup_camera()
	
	if enable_debug_mode:
		print("Sistema de point-and-click inicializado no Bar da Tia Ana")

func _setup_point_and_click_system():
	# Criar detector de cliques
	var detector_script = load("res://scripts/ClickDetector.gd")
	click_detector = detector_script.new()
	click_detector.enable_debug = enable_debug_mode
	add_child(click_detector)
	
	# Conectar sinais
	click_detector.object_clicked.connect(_on_object_clicked)

func _register_interactable_objects():
	# Encontrar e registrar todos os objetos interativos
	var tia_ana = find_child("TiaAna", true, false)
	if tia_ana and tia_ana.get_script():
		# Verificar se é uma instância de TiaAna ou InteractableObject
		var script = tia_ana.get_script()
		if script.get_global_name() == "TiaAna" or script.get_global_name() == "InteractableObject":
			click_detector.add_interactable_object(tia_ana)
			interactable_objects.append(tia_ana)
			print("Tia Ana registrada como objeto interativo")
	
	# Registrar outros objetos interativos (posters, terminais, etc.)
	_register_environment_objects()

func _register_environment_objects():
	# Registrar poster do Bruno
	var bruno_poster = find_child("Brunoposter", true, false)
	if bruno_poster:
		_make_object_interactable(bruno_poster, "Poster do Bruno", "Um poster promocional de um artista local.")
	
	# Registrar terminal pendurado
	var terminal = find_child("Hanging-terminal", true, false)
	if terminal:
		_make_object_interactable(terminal, "Terminal", "Um terminal de computador antigo pendurado na parede.")
	
	# Registrar notebook
	var notebook = find_child("Notebook", true, false)
	if notebook:
		_make_object_interactable(notebook, "Notebook", "Um notebook abandonado em uma mesa.")

func _make_object_interactable(node: Node2D, _name: String, _description: String):
	# Adicionar script InteractableObject ao nó
	# var interactable_script = load("res://scripts/InteractableObject.gd")
	# var script = interactable_script.new()
	# node.add_child(script)  # Comentado para evitar erro de RefCounted
	
	# Configurar propriedades
	# script.object_name = _name
	# script.description = description
	# script.available_actions.clear()
	# script.available_actions.append("Olhar")
	# script.available_actions.append("Tocar")
	
	# Adicionar área de colisão se não existir
	if not node.get_child(0) is Area2D:
		var area = Area2D.new()
		var collision_shape = CollisionShape2D.new()
		var rect_shape = RectangleShape2D.new()
		
		# Ajustar tamanho baseado no tipo de objeto
		if node is Sprite2D:
			var texture_size = node.texture.get_size()
			rect_shape.size = texture_size * node.scale
		else:
			rect_shape.size = Vector2(50, 50)
		
		collision_shape.shape = rect_shape
		area.add_child(collision_shape)
		node.add_child(area)
	
	# Registrar no sistema
	# click_detector.add_interactable_object(script)  # Comentado pois script não existe mais
	# interactable_objects.append(script)  # Comentado pois script não existe mais
	
	print("Objeto interativo criado: ", name)

func _setup_camera():
	var camera = find_child("Camera2D", true, false)
	if camera:
		# Configurar câmera para seguir o mouse (opcional)
		# camera.enabled = true
		pass

func _on_object_clicked(object: Node, _click_position: Vector2):
	if enable_debug_mode:
		print("Objeto clicado na cena do bar: ", object.object_name)

## Métodos para gerenciar interações específicas do bar

func start_bar_interaction():
	print("Iniciando interação especial do bar...")
	# Implementar lógica específica do bar

func on_tia_ana_talk():
	print("Tia Ana está falando...")
	# Lógica específica quando Tia Ana fala

func on_object_examined(object_name: String):
	print("Examinando: ", object_name)
	# Lógica para quando objetos são examinados

## Métodos de debug

func print_all_interactable_objects():
	print("=== Objetos Interativos no Bar ===")
	for obj in interactable_objects:
		print("- ", obj.object_name, ": ", obj.description)
		print("  Ações: ", obj.available_actions)

func test_interaction_system():
	print("Testando sistema de interação...")
	click_detector.print_registered_objects()

## Input handling para debug

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"): # "ui_cancel" is usually mapped to Escape key
		get_tree().change_scene_to_file("res://cenas/Game.tscn")
	# Existing debug input handling
	if enable_debug_mode:
		if event is InputEventKey:
			if event.pressed:
				match event.keycode:
					KEY_F1:
						print_all_interactable_objects()
					KEY_F2:
						test_interaction_system()
					KEY_F3:
						click_detector.enable_debug_mode(!click_detector.enable_debug)
