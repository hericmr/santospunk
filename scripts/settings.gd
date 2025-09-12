extends TabContainer

@export var pre_scene: Node

@onready var video: TabBar = $Video


func _ready():
	reload_settings()
	hide()
	

func reset_focus():
	if current_tab == 0: # Video
		$Video.grab_focus()
	elif current_tab == 1: # Audio
		$Audio.grab_focus()
	elif current_tab == 2: # Controls
		$Controls.grab_focus()

func reload_settings():
	video.load_video_settings()


func _on_back_pressed():
	hide()
	pre_scene.reset_focus()
	
