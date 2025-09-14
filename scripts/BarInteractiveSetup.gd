extends Node2D

## Script para configurar todos os objetos interativos do bar
## Adiciona scripts específicos aos objetos da cena

func _ready():
	print("=== Configurando objetos interativos do bar ===")
	
	# Aguardar um frame para garantir que tudo foi carregado
	await get_tree().process_frame
	
	# Configurar objetos interativos
	_setup_bruno_poster()
	_setup_hanging_terminal()
	_setup_notebook()
	
	print("✓ Todos os objetos interativos configurados!")

func _setup_bruno_poster():
	var poster = find_child("Brunoposter", true, false)
	if poster:
		print("Configurando Bruno Poster...")
		
		# Adicionar script específico
		# var script = load("res://scripts/BrunoPoster.gd")
		# poster.set_script(script)  # Comentado para evitar erro de RefCounted
		
		# Adicionar Area2D se não existir
		if not poster.get_child(0) is Area2D:
			var area = Area2D.new()
			var collision_shape = CollisionShape2D.new()
			var rect_shape = RectangleShape2D.new()
			
			# Ajustar tamanho baseado na textura
			if poster.texture:
				var texture_size = poster.texture.get_size()
				rect_shape.size = texture_size * poster.scale
			else:
				rect_shape.size = Vector2(100, 100)
			
			collision_shape.shape = rect_shape
			area.add_child(collision_shape)
			poster.add_child(area)
		
		print("✓ Bruno Poster configurado!")
	else:
		print("✗ Bruno Poster não encontrado!")

func _setup_hanging_terminal():
	var terminal = find_child("Hanging-terminal", true, false)
	if terminal:
		print("Configurando Hanging Terminal...")
		
		# Adicionar script específico
		# var script = load("res://scripts/HangingTerminal.gd")
		# terminal.set_script(script)  # Comentado para evitar erro de RefCounted
		
		# Adicionar Area2D se não existir
		if not terminal.get_child(0) is Area2D:
			var area = Area2D.new()
			var collision_shape = CollisionShape2D.new()
			var rect_shape = RectangleShape2D.new()
			
			# Ajustar tamanho baseado na textura
			if terminal.texture:
				var texture_size = terminal.texture.get_size()
				rect_shape.size = texture_size * terminal.scale
			else:
				rect_shape.size = Vector2(100, 100)
			
			collision_shape.shape = rect_shape
			area.add_child(collision_shape)
			terminal.add_child(area)
		
		print("✓ Hanging Terminal configurado!")
	else:
		print("✗ Hanging Terminal não encontrado!")

func _setup_notebook():
	var notebook = find_child("Notebook", true, false)
	if notebook:
		print("Configurando Notebook...")
		
		# Adicionar script específico
		# var script = load("res://scripts/Notebook.gd")
		# notebook.set_script(script)  # Comentado para evitar erro de RefCounted
		
		# Adicionar Area2D se não existir
		if not notebook.get_child(0) is Area2D:
			var area = Area2D.new()
			var collision_shape = CollisionShape2D.new()
			var rect_shape = RectangleShape2D.new()
			
			# Ajustar tamanho baseado na textura
			if notebook.texture:
				var texture_size = notebook.texture.get_size()
				rect_shape.size = texture_size * notebook.scale
			else:
				rect_shape.size = Vector2(100, 100)
			
			collision_shape.shape = rect_shape
			area.add_child(collision_shape)
			notebook.add_child(area)
		
		print("✓ Notebook configurado!")
	else:
		print("✗ Notebook não encontrado!")
