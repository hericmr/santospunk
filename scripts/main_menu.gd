extends Control

@onready var option_menu: TabContainer = $"../Settings"
@onready var anim_player: AnimationPlayer = $"../../AnimationPlayer"

func _ready():
	anim_player.play("personagens")
	$VBoxContainer/Start.grab_focus()

func reset_focus():
	$VBoxContainer/Start.grab_focus()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://cenas/historia.tscn")

func _on_option_pressed():
	option_menu.show()
	option_menu.reset_focus()
	anim_player.play("personagens")  # toca a animação quando abre opções
	AudioManager.play_button_sound()

func _on_quit_pressed():
	get_tree().quit()
