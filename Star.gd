extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var is_selected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Ready")
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('walk_down'):
		if is_selected:
			$star_black.visible = false
			$star_yellow.visible = false
			$star_blue.visible = true

func _on_Area2D_area_entered(area):
	is_selected = true
	$star_black.visible = false
	$star_yellow.visible = true
	$star_blue.visible = false

func _on_Area2D_area_exited(area):
	is_selected = false
	$star_black.visible = true
	$star_yellow.visible = false
	$star_blue.visible = false
