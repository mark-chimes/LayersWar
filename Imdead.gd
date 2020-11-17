extends Node2D

signal encounter_enemy(identity)
signal death(identity)

enum Direction { 
	LEFT, RIGHT
}

enum State {
	WALK,
	ATTACK,
	DIE,
	IDLE
}

export var velocity = 10
export var army_direction = Direction.LEFT

var state = State.WALK
var direction = Direction.LEFT

var is_walking_to_desired = false
var desired_x_pos = 0

var epsilon = 4

func _ready():	
	walk()

func _process(delta):
	if is_walking_to_desired:
		if abs(position.x - desired_x_pos) > 4:
			if position.x > desired_x_pos:
				direction = Direction.LEFT
			else: 
				direction = Direction.RIGHT
			walk()
		else: 
			direction = army_direction
			idle()
	else: 
		direction = army_direction

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
	if area_name == "KnightArea2D":
		emit_signal("encounter_enemy", self)
#	elif area_name == "ImdeadArea2D" and state == State.WALK:
#		idle()
		
func _on_AnimatedSprite_animation_finished():
	if state == State.ATTACK:
		die()
	elif state == State.DIE:
		queue_free()

func idle(): 
#	print(get_name() + " is idle")
	$AnimatedSprite.play("idle")
	state = State.IDLE

func attack(): 
#	print(get_name() + " is attacking")
	$AnimatedSprite.play("attack")
	state = State.ATTACK

func walk(): 
#	print(get_name() + " is walking")
	$AnimatedSprite.play("walk")
	state = State.WALK
	
func walk_to_desired(given_desired_x_pos): 
	desired_x_pos = given_desired_x_pos
	# print("Unit " + get_name() + " position " + str(position.x) + " / " + str(desired_x_pos))
	is_walking_to_desired = true
	desired_x_pos = given_desired_x_pos

func march(): 
	is_walking_to_desired = false
	walk()

func die(): 
#	print(get_name() + " is dying")
	$AnimatedSprite.play("death")
	state = State.DIE
	emit_signal("death", self)

# DEBUG
func _on_ImdeadArea2D_mouse_entered():
	print("Mouse on " + get_name())
