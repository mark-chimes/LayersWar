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

export (PackedScene) var unit_type = load("res://Imdead.tscn")
export (String) var unit_type_name = "Imdead"

var units_array = []

var front_march_unit
var front_attack_unit
var cur_enemy

signal register_army(army)
signal front_unit_attack

export var num_units_to_spawn = 2
export var distance_between_spawned = 40

var unit_num_for_name = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.MARCH
	$Sprite.visible = false
	emit_signal("register_army", self)
	for i in range(0, num_units_to_spawn):
		create_unit(global_position + Vector2(i*distance_between_spawned,0))
		
func create_unit(unit_pos):
	var unit_instance = unit_type.instance()
	unit_instance.set_name(unit_type_name + str(unit_num_for_name))
	add_child(unit_instance)
	unit_instance.position = unit_pos - global_position
#	unit_instance.scale = Vector2( -1, 1 )
	unit_instance.army_direction = direction
	unit_instance.velocity = 20
	unit_instance.z_index = 1
	unit_instance.connect("encounter_enemy", self, "_on_unit_encounter_enemy")
	unit_instance.connect("death", self, "_on_unit_death")
	unit_instance.connect("unit_attack", self, "_on_front_unit_attack")
	units_array.append(unit_instance)
	unit_num_for_name += 1
	
	if state == State.MARCH: 
		if units_array.size() > 1:
			unit_instance.march_with(front_march_unit, units_array.size()-1)
		else: 
			unit_instance.march()
			front_march_unit = unit_instance
	elif state == State.ATTACK: 
		if units_array.size() > 1:
			var base_pos = front_attack_unit.position.x
			var desired_pos = base_pos + 32*(units_array.size() - 1)
			unit_instance.walk_to_desired(desired_pos)
		else: 
			state = State.MARCH
			unit_instance.march()
			front_march_unit = unit_instance

func _on_front_unit_attack():
	emit_signal("front_unit_attack")

func _on_unit_encounter_enemy(identity, enemy):
	cur_enemy = enemy#.get_army()
	enemy.connect("unit_die", self, "_on_enemy_death")
	enemy.connect("unit_attack", self, "_on_enemy_attack")
	self.connect("front_unit_attack", enemy, "_on_front_enemy_attack")
	if state != State.ATTACK:
		start_attacking()

func start_attacking():
	state = State.ATTACK
	front_attack_unit = units_array.front()
	front_attack_unit.attack()
	
	var base_pos = front_attack_unit.position.x
	
	var i = -1
	for unit in units_array:
		i += 1
		if i == 0:
			continue
		var desired_pos = base_pos + 32*i
		unit.walk_to_desired(desired_pos)

func _on_unit_death(identity):
	cur_enemy.on_front_enemy_death()
	units_array.remove(units_array.find(identity))
	start_attacking()

func start_marching(): 
	state = State.MARCH
	front_march_unit = units_array.front()
	front_march_unit.march()
	var i = -1
	for unit in units_array:
		i += 1
		if i == 0:
			continue
		unit.march_with(front_march_unit, i)

# TODO What happens when they kill the enemy without losing a unit?!
func _on_enemy_death():
	start_marching()
	
func _on_enemy_attack():
	front_attack_unit.take_damage()
