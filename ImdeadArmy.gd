extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var units_array = []
var imdead = load("res://Imdead.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$goblin.visible = false
	create_imdead("Imdead1", Vector2(0,0) )
	create_imdead("Imdead2", Vector2(64,0))
	create_imdead("Imdead3", Vector2(128,0))
	create_imdead("Imdead4", Vector2(156,0))

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
	print("Imdead_instance " + str(imdead_instance))
	units_array.append(imdead_instance)

func _on_Imdead_encounter_enemy(identity):
	print("Encountered enemy: " + identity.get_name())
	print("Units array: " + str(units_array))
	print("Imdead_identity: " + str(identity))
	units_array.pop_front().attack()
	for unit in units_array:
		unit.idle()
	
func _on_Imdead_death(identity):
	print("Imdead died: " + identity.get_name())
	print("Imdead_identity: " + str(identity))
#	units_array.remove(units_array.find(identity))
	print("Units array: " + str(units_array))
	print("Telling " + identity.get_name() + " to walk.")
	for unit in units_array:
		unit.walk()

