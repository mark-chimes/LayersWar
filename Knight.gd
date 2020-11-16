extends Node2D

export var velocity = 10
var cur_velocity

enum State {
	RUN,
	ATTACK,
	DIE,
	IDLE
}

var state = State.RUN

func _ready():
	cur_velocity = velocity
	$AnimatedSprite.play("walk")
	
func _process(delta):
	if state == State.RUN:
		position.x = position.x + cur_velocity*delta	

func _on_Area2D_area_entered(area):
	$AnimatedSprite.play("attack")
	state = State.ATTACK

func _on_AnimatedSprite_animation_finished():
	if state == State.ATTACK:
		$AnimatedSprite.play("idle")
		state = State.IDLE
