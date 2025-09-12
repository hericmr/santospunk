extends Node2D

@onready var video_player = $VideoStreamPlayer

func _ready():
	video_player.finished.connect(_on_video_finished)
	video_player.grab_focus()

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		_on_video_finished()

func _on_video_finished():
	get_tree().change_scene_to_file("res://cenas/Game.tscn")
