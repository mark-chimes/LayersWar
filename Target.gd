extends Node2D

signal register_target(target_x_pos)

func _ready():
	emit_signal("register_target", position.x)

