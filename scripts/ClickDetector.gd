extends Node
class_name ClickDetector

signal object_clicked(object, click_position)

var interactable_objects: Array = []
var enable_debug: bool = false

func _input(event):
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        var mouse_pos = event.position
        var world_space_state = get_viewport().get_world_2d().direct_space_state
        var query = PhysicsPointQueryParameters2D.new()
        query.position = get_viewport().get_camera_2d().get_global_mouse_position()
        var result = world_space_state.intersect_point(query, 1)

        for res in result:
            var object = res.collider
            if object in interactable_objects:
                emit_signal("object_clicked", object, event.position)
                if enable_debug:
                    print("Clicked on: ", object.object_name)
                return

func add_interactable_object(object):
    interactable_objects.append(object)

func print_registered_objects():
    print("Registered objects:")
    for obj in interactable_objects:
        print("- ", obj.object_name)
