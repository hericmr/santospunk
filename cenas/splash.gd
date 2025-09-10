extends Node2D

func _ready():
	$FadeLogo.play("fadein_e_fadeout")


func _on_fade_logo_animation_finished(anim_name: StringName):
	get_tree().change_scene_to_file("res://cenas/Game.tscn")
