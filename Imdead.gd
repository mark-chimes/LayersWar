extends Node2D

signal encounter_enemy(identity)
signal death(identity)

export var velocity = 10

enum State {
	WALK,
	ATTACK,
	DIE,
	IDLE
}

var state = State.WALK

func _ready():
	walk()

func _process(delta):
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
	print(get_name() + " is idle")
	$AnimatedSprite.play("idle")
	state = State.IDLE

func attack(): 
	print(get_name() + " is attacking")
	$AnimatedSprite.play("attack")
	state = State.ATTACK

func walk(): 
	print(get_name() + " is walking")
	$AnimatedSprite.play("walk")
	state = State.WALK

func die(): 
	print(get_name() + " is dying")
	$AnimatedSprite.play("death")
	state = State.DIE
	emit_signal("death", self)
