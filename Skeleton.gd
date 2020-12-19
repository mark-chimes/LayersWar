extends Node2D

var desired_x_pos = 0
var epsilon = 4

export var velocity = 40

enum State {
	GET_IN_POS,
	ATTACK,
	DEFEND,
	WAIT
}

var state = State.GET_IN_POS

var army_locator = null

func _ready():
	pass

func _process(delta):
	if army_locator == null: 
		return
	if state == State.GET_IN_POS:
		if abs(position.x - desired_x_pos) > epsilon:
			$AnimatedSprite.play("walk")
			if position.x < desired_x_pos: 
				position.x = position.x + velocity*delta
				$AnimatedSprite.flip_h = false
			else: 
				position.x = position.x - velocity*delta
				$AnimatedSprite.flip_h = true
		else: 
			$AnimatedSprite.play("idle")
	elif state == State.ATTACK: 
		print("ATTACK2")
		$AnimatedSprite.play("attack")
	elif state == State.DEFEND: 
		$AnimatedSprite.play("death") # TODO: need a defense animation
	elif state == State.WAIT: 
		$AnimatedSprite.play("idle")
		
func attack(): 
	state = State.ATTACK

func defend(): 
	state = State.DEFEND
		
func get_in_pos(): 
	state = State.GET_IN_POS

func set_target_position(target_position): 
	desired_x_pos = target_position

func _on_AnimatedSprite_animation_finished():
	if state == State.ATTACK or state == State.DEFEND:
		print("ANIMATION FINISHED")
		state = State.WAIT
