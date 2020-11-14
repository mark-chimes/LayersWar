extends Node2D

func _on_Star_selected(selection_position):
	print(selection_position)
	print(position)
	var tent = load("res://Tent.tscn")
	var tent_instance = tent.instance()
	tent_instance.set_name("tent")
	add_child(tent_instance)
	tent_instance.position = selection_position
	tent_instance.z_index = 1
