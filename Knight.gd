extends Node2D

export var velocity = 10
var cur_velocity

export var hp = 5

enum State {
	WALK,
	ATTACK,
	DIE,
	IDLE
}

var state = State.WALK

func _ready():
	cur_velocity = velocity
	$AnimatedSprite.play("walk")
	
func _process(delta):
	if state == State.WALK:
		position.x = position.x + cur_velocity*delta	

func _on_Area2D_area_entered(area):
	$AnimatedSprite.play("attack")
	state = State.ATTACK

func _on_AnimatedSprite_animation_finished():
	if state == State.ATTACK:
		hp -= 1
		if hp > 0:
			$AnimatedSprite.play("walk")
			state = State.WALK
		else: 
			$AnimatedSprite.play("death")
			state = State.DIE
			$KnightArea2D.queue_free()
	elif state == State.DIE:
		queue_free()
