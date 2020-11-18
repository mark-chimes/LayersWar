extends Node2D

var imdead_army

func _ready():
	pass # Replace with function body.
	
func _on_ImdeadArmy_register_army(army):
	imdead_army = army
	
func _on_SpawnTimer_timeout():
	imdead_army.create_unit(global_position)
