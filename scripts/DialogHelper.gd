extends Node

var dialog_overlay_scene: PackedScene = preload("res://cenas/DialogOverlay.tscn")
var dialog_overlay_instance

func _ready():
    # DialogOverlay is instantiated when needed, not at _ready
    pass

func start_tia_ana_dialogue():
    var dialogue_text = "Tia Ana: Olá, meu querido. O de sempre?\nVocê: Sim, por favor. Um café bem forte.\nTia Ana: Pra já. O movimento está fraco hoje, não acha?\nVocê: É o que parece. Talvez a chuva tenha espantado os clientes."
    _show_dialog_overlay(null, null, dialogue_text)

func get_dialog_box():
    # This function might not be directly compatible with the old DialogOverlay
    # as it doesn't return a "box" but rather manages the overlay directly.
    # For now, return the instance if it exists.
    return dialog_overlay_instance

func start_simple_dialogue(line, character_name):
    var formatted_text = character_name + ": " + line
    _show_dialog_overlay(null, null, formatted_text)

func start_custom_dialogue(character_name, lines, face_texture = null, background_texture = null):
    var formatted_text = ""
    for line in lines:
        formatted_text += character_name + ": " + line + "\n"
    _show_dialog_overlay(background_texture, face_texture, formatted_text)

func _show_dialog_overlay(poster_texture: Texture2D, face_texture: Texture2D, dialog_text: String):
    if dialog_overlay_instance and is_instance_valid(dialog_overlay_instance):
        dialog_overlay_instance.queue_free() # Remove existing one if any

    dialog_overlay_instance = dialog_overlay_scene.instantiate()
    get_tree().current_scene.add_child(dialog_overlay_instance)

    if poster_texture:
        dialog_overlay_instance.poster_texture = poster_texture
    if face_texture:
        dialog_overlay_instance.face_texture = face_texture
    if dialog_text:
        dialog_overlay_instance.dialog_text = dialog_text
    
    # Call _ready() manually if it's not called automatically for some reason
    # dialog_overlay_instance._ready()

# Other functions from the README (adjusting for DialogOverlay API)
func set_dialogue_theme(theme_name):
    # This functionality needs to be implemented within DialogOverlay.gd if desired
    pass

func start_poster_dialogue():
    # This will be handled by Poster.gd directly, not DialogHelper
    pass

func start_terminal_dialogue():
    # This will be handled by HangingTerminal.gd directly, not DialogHelper
    pass

func start_notebook_dialogue():
    # This will be handled by Notebook.gd directly, not DialogHelper
    pass

func is_dialogue_active():
    return dialog_overlay_instance and is_instance_valid(dialog_overlay_instance) and dialog_overlay_instance.is_visible_in_tree()

func close_current_dialogue():
    if dialog_overlay_instance and is_instance_valid(dialog_overlay_instance):
        dialog_overlay_instance._close_dialog()

func add_custom_dialogue_line(character_name, line):
    # This functionality needs to be implemented within DialogOverlay.gd if desired
    pass

func get_dialogue_stats():
    return {} # Not implemented yet

func save_dialogues_to_file(path):
    pass # Not implemented yet

func load_dialogues_from_file(path):
    pass # Not implemented yet
