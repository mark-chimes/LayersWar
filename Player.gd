extends Node2D

var v_speed = 0
var v_acc = 200
var v_terminal = 1000

export (int) var speed = 200
var velocity = Vector2()

func _ready():	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.x > 0 and position.x < 1024: 
		velocity = Vector2()
		if Input.is_action_pressed('walk_right'):
			velocity.x += 1
		if Input.is_action_pressed('walk_left'):
			velocity.x -= 1
		velocity = velocity.normalized() * speed
		
		if velocity.x < -0.5: 
			$AnimatedSprite.flip_h = true
		elif velocity.x > 0.5: 
			$AnimatedSprite.flip_h = false

		if velocity.length() > 0: 
			$AnimatedSprite.playing = true
		else: 
			$AnimatedSprite.playing = false
	else:
		if v_speed < v_terminal: 
			v_speed += delta*v_acc
		velocity.y += delta * v_speed
					
	position = position + velocity*delta	
