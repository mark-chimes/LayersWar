extends Node2D

export var velocity = 10

func _ready():
	pass # Replace with function body.

func _process(delta):
	position.x = position.x + velocity*delta	
