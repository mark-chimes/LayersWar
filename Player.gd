extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#var h_speed = 50
#var v_speed = 0
#var v_acc = 200
#var v_terminal = 1000

export (int) var speed = 200
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2()
	if Input.is_action_pressed('walk_right'):
		velocity.x += 1
	if Input.is_action_pressed('walk_left'):
		velocity.x -= 1
#	if Input.is_action_pressed('walk_down'):
#		velocity.y += 1
#	if Input.is_action_pressed('walk_up'):
#		velocity.y -= 1
	velocity = velocity.normalized() * speed
	
	if velocity.x < -1: 
		$AnimatedSprite.flip_h = true
	elif velocity.x > 1: 
		$AnimatedSprite.flip_h = false

	if velocity.length() > 0: 
		$AnimatedSprite.playing = true
	else: 
		$AnimatedSprite.playing = false

	
	position = position + velocity*delta

#	if position.x < 1024: 
#		position = position + Vector2(delta * h_speed, 0)
#	else: 
#		if v_speed < v_terminal: 
#			v_speed += delta*v_acc
#		position = position + Vector2(delta * h_speed, delta * v_speed)
