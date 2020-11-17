extends Node2D

export var velocity = 10

enum State {
	WALK,
	ATTACK,
	DIE,
	IDLE
}

var state = State.WALK

func _ready():
	$AnimatedSprite.play("walk")

func _process(delta):
	if state == State.WALK:
		position.x = position.x + velocity*delta	

func _on_Area2D_area_entered(area):
	var area_name = area.get_name()
	print(area_name)
	if area_name == "KnightArea2D":
		$AnimatedSprite.play("attack")
		state = State.ATTACK

func _on_AnimatedSprite_animation_finished():
	if state == State.ATTACK:
		$AnimatedSprite.play("death")
		state = State.DIE
	elif state == State.DIE:
		queue_free()
