extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var units_array = []
var imdead = load("res://Imdead.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$goblin.visible = false
	# TODO base yourself on the position of the front unit, if they exist
	create_imdead("Imdead1", Vector2(0,0) )
	create_imdead("Imdead2", Vector2(40,0))
	create_imdead("Imdead3", Vector2(80,0))
	create_imdead("Imdead4", Vector2(120,0))
	create_imdead("Imdead5", Vector2(160,0))
	create_imdead("Imdead6", Vector2(200,0))
		
func create_imdead(unit_name, unit_pos):
	var imdead_instance = imdead.instance()
	imdead_instance.set_name(unit_name)
	add_child(imdead_instance)
	imdead_instance.position = unit_pos
	imdead_instance.scale = Vector2( -1, 1 )
	imdead_instance.velocity = -20
	imdead_instance.z_index = 1
	imdead_instance.connect("encounter_enemy", self, "_on_Imdead_encounter_enemy")
	imdead_instance.connect("death", self, "_on_Imdead_death")
	units_array.append(imdead_instance)

func _on_Imdead_encounter_enemy(identity):
#	print("Encountered enemy: " + identity.get_name())
#	print("Units array: " + str(units_array))
#	print("Imdead_identity: " + str(identity))
	var front_unit = units_array.pop_front()
	front_unit.attack()
	
	var base_pos = front_unit.position.x
	print("Base pos: " + str(base_pos))
	
	var i = 0
	for unit in units_array:
		i += 1
		var desired_pos = base_pos + 32*i
		unit.walk_to_desired(desired_pos)
	
func _on_Imdead_death(identity):
#	units_array.remove(units_array.find(identity))
	for unit in units_array:
		unit.march()

