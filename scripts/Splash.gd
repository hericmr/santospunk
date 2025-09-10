extends Node2D

@onready var animation_player: AnimationPlayer = $FadeLogo

func _ready():
    if animation_player:
        # Play the main splash animation if present
        if animation_player.has_animation("fadein_e_fadeout"):
            animation_player.play("fadein_e_fadeout")

    var timer := Timer.new()
    # Slightly longer than the animation to avoid abrupt cut
    timer.wait_time = 7.2
    timer.one_shot = true
    timer.timeout.connect(_on_timer_timeout)
    add_child(timer)
    timer.start()

func _on_timer_timeout():
    get_tree().change_scene_to_file("res://cenas/Game.tscn")


