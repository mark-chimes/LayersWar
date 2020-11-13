extends Camera2D

var _dragging = false


func _ready():
	set_process_input(true)


func _input(event):

	# Note: on mobile, Godot emulates mouse events,
	# so it should work on desktop too without changes.

	if event.type == InputEvent.MOUSE_BUTTON:
		_dragging = event.pressed

	elif event.type == InputEvent.MOUSE_MOVE and _dragging:
		var motion = Vector2(event.relative_x, event.relative_y)
		set_position(get_position() + motion)
