extends Control

## Script do Menu Principal
## Controla as ações do menu inicial do jogo

func _ready():
	print("=== Menu Principal Carregado ===")
	
	# Conectar sinais dos botões se existirem
	_setup_button_connections()

func _setup_button_connections():
	# Procurar pelo botão Start
	var start_button = find_child("Start", true, false)
	if start_button:
		if not start_button.pressed.is_connected(_on_start_pressed):
			start_button.pressed.connect(_on_start_pressed)
		print("✓ Botão Start conectado!")
	else:
		print("✗ Botão Start não encontrado!")

func _on_start_pressed():
	print("Botão Start pressionado!")
	
	# Mudar para a cena de introdução
	var intro_scene_path = "res://cenas/historia.tscn"
	if ResourceLoader.exists(intro_scene_path):
		var result = get_tree().change_scene_to_file(intro_scene_path)
		if result == OK:
			print("✓ Transição para a introdução concluída!")
		else:
			print("✗ Erro ao mudar para a introdução - Código: ", result)
	else:
		print("✗ Cena de introdução não encontrada: ", intro_scene_path)

## Método para pular para o bar (útil para debug)
func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("Pulando para o bar pelo teclado!")
		_on_start_pressed()
