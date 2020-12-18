extends Node2D

enum Direction { 
	LEFT, RIGHT
}

enum State {
	WAIT,
	MARCH,
	ATTACK
}

enum ArmyTeam { 
	ELF,
	DWARF,
	ORC,
	HUMAN
}

signal register_army(army, team)

var state = State.WAIT

var units_array = []
export (PackedScene) var unit_type = load("res://Skeleton.tscn")
export (String) var unit_type_name = "Skeleton"
export var num_units_to_spawn = 2
export var distance_between_units = 40
export (Direction) var startDirection = Direction.LEFT 
var direction = startDirection
export var march_speed = 40
export (ArmyTeam) var team = ArmyTeam.HUMAN

var unit_num_for_name = 0
var epsilon = 4

var has_checkpoint = false
var checkpoint_x_pos = 0
onready var army_locator = get_node("ArmyLocator")

func _ready():
	emit_signal("register_army", self, team)
	spawn_initial_units()
			
func _process(delta):
	march_army_to_target(delta)
	update_units_to_walk_with_army()

func march_army_to_target(delta): 
	var cur_x_pos = army_locator.position.x
	
	if state == State.WAIT:
		return
	elif state == State.MARCH:
		if has_checkpoint == false: 
			state = State.WAIT
			return
		
		if abs(cur_x_pos - checkpoint_x_pos) <= epsilon:
			has_checkpoint = false
			state = State.WAIT
			return
		
		if checkpoint_x_pos > cur_x_pos:
			direction = Direction.RIGHT
		else: 
			direction = Direction.LEFT
		
		if direction == Direction.RIGHT:
			army_locator.position.x = cur_x_pos + march_speed*delta
		else: 
			army_locator.position.x = cur_x_pos - march_speed*delta
	elif state == State.ATTACK:
		return
		
func update_units_to_walk_with_army(): 
	var unit_count = 0
	for unit in units_array: 
		var target_position
		if direction == Direction.RIGHT:
			target_position = army_locator.position.x - distance_between_units*unit_count
		else: 
			target_position = army_locator.position.x + distance_between_units*unit_count
		unit.set_target_position(target_position)
		unit_count += 1

func spawn_initial_units():
	for i in range(0, num_units_to_spawn):
		if startDirection == Direction.RIGHT:
			create_unit(global_position - Vector2(i*distance_between_units,0))
		else: 
			create_unit(global_position + Vector2(i*distance_between_units,0))

func create_unit(unit_pos):
	var unit_instance = unit_type.instance()
	unit_instance.set_name(unit_type_name + str(unit_num_for_name))
	add_child(unit_instance)
	unit_instance.position = unit_pos + army_locator.position
#	unit_instance.scale = Vector2( -1, 1 )
#	unit_instance.army_direction = direction
	unit_instance.velocity = march_speed
#	unit_instance.z_index = 1
#	unit_instance.connect("encounter_enemy", self, "_on_unit_encounter_enemy")
#	unit_instance.connect("death", self, "_on_unit_death")
#	unit_instance.connect("unit_attack", self, "_on_front_unit_attack")
	units_array.append(unit_instance)
	unit_num_for_name += 1

func _on_register_checkpoint(new_checkpoint_x_pos):
	state = State.MARCH
	checkpoint_x_pos = new_checkpoint_x_pos
	has_checkpoint = true

func get_position(): 
	return army_locator.position.x

func start_attack(): 
	if state == State.ATTACK:
		return
	state = State.ATTACK
	# TODO Attack orders ?
