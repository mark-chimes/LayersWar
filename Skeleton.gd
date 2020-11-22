extends Node2D

var desired_x_pos
var epsilon = 4

export var velocity = 40

func _ready():
	pass

func _process(delta):
	if abs(position.x - desired_x_pos) > epsilon:
		if position.x < desired_x_pos: 
			position.x = position.x + velocity*delta
		else: 
			position.x = position.x - velocity*delta
	
func set_target_position(target_position): 
	desired_x_pos = target_position
