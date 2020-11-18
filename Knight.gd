extends Node2D

signal knight_die
signal knight_attack

export var velocity = 10
var cur_velocity

export var hp = 3

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
		emit_signal("knight_attack")

	elif state == State.DIE:
		queue_free()

func _on_imdead_attack(): 
	hp -= 1
	if hp <= 0:
		$AnimatedSprite.play("death")
		state = State.DIE
		emit_signal("knight_die")
		$KnightArea2D.queue_free()

func on_skeleton_death():
	$AnimatedSprite.play("walk")
	state = State.WALK
