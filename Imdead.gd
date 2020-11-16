extends Node2D

export var velocity = 10

enum State {
	WALK,
	ATTACK,
	DIE
}

var state = State.WALK

func _ready():
	pass # Replace with function body.

func _process(delta):
	if state == State.WALK:
		position.x = position.x + velocity*delta	

func _on_Area2D_area_entered(area):
	$AnimatedSprite.play("attack")
	state = State.ATTACK

func _on_AnimatedSprite_animation_finished():
	if state == State.ATTACK:
		$AnimatedSprite.play("death")
		state = State.DIE
	elif state == State.DIE:
		queue_free()
