extends Node2D


enum Direction { 
	LEFT, RIGHT
}

enum State {
	MARCH,
	ATTACK
}

export var state = State.MARCH
export var direction = Direction.LEFT

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var units_array = []
var imdead = load("res://Imdead.tscn")
var front_march_unit
var front_attack_unit

signal register_army(army)

export var num_units_to_spawn = 2
export var distance_between_spawned = 40

var unit_num_for_name = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.MARCH
	$goblin.visible = false
	emit_signal("register_army", self)
	
	print("Position: " + str(get_position()))
	print("Global position: " + str(global_position))
	
	for i in range(0, num_units_to_spawn):
		create_imdead(global_position + Vector2(i*distance_between_spawned,0))
		
func create_imdead(unit_pos):
	var imdead_instance = imdead.instance()
	imdead_instance.set_name("Imdead" + str(unit_num_for_name))
	add_child(imdead_instance)
	imdead_instance.position = unit_pos - global_position
#	imdead_instance.scale = Vector2( -1, 1 )
	imdead_instance.army_direction = direction
	imdead_instance.velocity = 20
	imdead_instance.z_index = 1
	imdead_instance.connect("encounter_enemy", self, "_on_Imdead_encounter_enemy")
	imdead_instance.connect("death", self, "_on_Imdead_death")
	units_array.append(imdead_instance)
	unit_num_for_name += 1
	
	if state == State.MARCH: 
		if units_array.size() > 1:
			imdead_instance.march_with(front_march_unit, units_array.size()-1)
		else: 
			imdead_instance.march()
			front_march_unit = imdead_instance
	elif state == State.ATTACK: 
		if units_array.size() > 1:
			var base_pos = front_attack_unit.position.x
			var desired_pos = base_pos + 32*(units_array.size() - 1)
			imdead_instance.walk_to_desired(desired_pos)
		else: 
			state = State.MARCH
			imdead_instance.march()
			front_march_unit = imdead_instance

func _on_Imdead_encounter_enemy(identity):
	if state != State.ATTACK:
		state = State.ATTACK
		front_attack_unit = units_array.pop_front()
		front_attack_unit.attack()
		var base_pos = front_attack_unit.position.x
			
		var i = 0
		for unit in units_array:
			i += 1
			var desired_pos = base_pos + 32*i
			unit.walk_to_desired(desired_pos)
	
func _on_Imdead_death(identity):
	units_array.remove(units_array.find(identity))
	if state != State.MARCH:
		state = State.MARCH
		front_march_unit = units_array.pop_front()
		front_march_unit.march()
		var i = 0
		for unit in units_array:
			i += 1
			unit.march_with(front_march_unit, i)
		units_array.push_front(front_march_unit)

# TODO What happens when they kill the enemy without losing a unit?!
