extends Node2D

func _ready():
	# Configurar input para voltar
	set_process_input(true)

func _input(event):
	# Voltar para a cena anterior quando pressionar ESC
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Game.tscn")
