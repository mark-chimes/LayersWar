extends Node2D

signal encounter_enemy(identity, enemy)
signal death(identity)

signal unit_attack

enum Direction { 
	LEFT, RIGHT
}

enum MacroState { 
	LEAD_COMBAT,
	WAIT_COMBAT,
	LEAD_MARCH,
	FOLLOW_MARCH,
	DIE
}

enum State {
	WALK,
	ATTACK,
	DIE,
	IDLE
}

export var hp = 1

export var velocity = 10
export var army_direction = Direction.LEFT

var macro_state = MacroState.LEAD_MARCH
var state = State.WALK
var direction = Direction.LEFT

var march_index = 0
var march_leader = null
var desired_x_pos = 0

var epsilon = 4


func _ready():
	walk()

func _process(delta):
	if macro_state == MacroState.DIE:
		return
		
	if macro_state == MacroState.WAIT_COMBAT:
		if abs(position.x - desired_x_pos) > epsilon:
			if position.x > desired_x_pos:
				direction = Direction.LEFT
			else: 
				direction = Direction.RIGHT
			walk()
		else: 
			direction = army_direction
			idle()
	elif macro_state == MacroState.FOLLOW_MARCH:
		if march_leader == null: 
			print("MARCH LEADER FOR " + get_name() + " IS NULL ")
		if army_direction == Direction.LEFT: 
			desired_x_pos = march_leader.position.x + march_index*32
			if abs(position.x - desired_x_pos) > epsilon:
				if position.x > desired_x_pos: # walking left, too far right, catch up
					direction = Direction.LEFT
					walk()
				else: # walking left, too far left, run into position
					direction = Direction.RIGHT 
					walk()
		elif army_direction == Direction.RIGHT:  
			desired_x_pos = march_leader.position.x - march_index*32
			if abs(position.x - desired_x_pos) > epsilon:
				if position.x > desired_x_pos: # walking right, too far right, run into position
					direction = Direction.LEFT
					walk()
				else: # walking right, too far left, catch up
					direction = Direction.RIGHT
					walk()
					
	if direction == Direction.LEFT:
		$AnimatedSprite.flip_h = true
		if state == State.WALK:
			position.x = position.x - velocity*delta
	elif direction == Direction.RIGHT:
		$AnimatedSprite.flip_h = false
		if state == State.WALK:
			position.x = position.x + velocity*delta

func _on_Area2D_area_entered(area):
	var area_name = area.get_name()
	var enemy = area.get_parent()
	if area_name == "KnightArea2D":
		emit_signal("encounter_enemy", self, enemy)
#	elif area_name == "ImdeadArea2D" and state == State.WALK:
#		idle()

func _on_AnimatedSprite_animation_finished():
	if state == State.ATTACK:
		emit_signal("unit_attack")
	if state == State.DIE:
		queue_free()

func take_damage(): 
	hp -= 1
	if hp <= 0:
		die()

func idle(): 
	$AnimatedSprite.play("idle")
	state = State.IDLE
	
func attack(): 
	$AnimatedSprite.play("attack")
	state = State.ATTACK
	macro_state = MacroState.LEAD_COMBAT

func walk(): 
	$AnimatedSprite.play("walk")
	state = State.WALK
	
func walk_to_desired(given_desired_x_pos): 
	desired_x_pos = given_desired_x_pos
	# print("Unit " + get_name() + " position " + str(position.x) + " / " + str(desired_x_pos))
	macro_state = MacroState.WAIT_COMBAT
	desired_x_pos = given_desired_x_pos

func march(): 
	macro_state = MacroState.LEAD_MARCH
	walk()

func march_with(front_unit, my_index):
	if front_unit == null: 
		print(get_name() + " was told to follow a null unit ")
	macro_state = MacroState.FOLLOW_MARCH
	march_leader = front_unit
	march_index = my_index
	walk()

func die(): 
	$AnimatedSprite.play("death")
	state = State.DIE
	macro_state = MacroState.DIE
	emit_signal("death", self)

# DEBUG
func _on_ImdeadArea2D_mouse_entered():
	print("Mouse on " + get_name())
