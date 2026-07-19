extends Control

@export var max_distance: float = 50.0
@export var deadzone: float = 0.2

# Updated node paths to match your new hierarchy
@onready var joystick: TouchScreenButton = $joystick
@onready var knob: Sprite2D = $joystick/knob

var center_point: Vector2
var joystick_vector: Vector2 = Vector2.ZERO
var active_touch_index: int = -1

func _ready() -> void:
	# Calculate the exact center of your base texture on the TouchScreenButton
	if joystick.texture_normal:
		center_point = joystick.texture_normal.get_size() / 2.0
	else:
		center_point = Vector2.ZERO
	
	# Snap the knob to the center on load
	knob.position = center_point

func _input(event: InputEvent) -> void:
	# Catch the initial touch down
	if event is InputEventScreenTouch:
		# is_pressed() checks if the touch is within the TouchScreenButton's area
		if event.pressed and joystick.is_pressed() and active_touch_index == -1:
			active_touch_index = event.index # Lock onto this specific finger
			_update_joystick(event.position)
		# Catch when that specific finger lets go
		elif not event.pressed and event.index == active_touch_index:
			_reset_joystick()
			
	# Catch the dragging motion of that specific finger
	if event is InputEventScreenDrag and event.index == active_touch_index:
		_update_joystick(event.position)

func _update_joystick(touch_pos: Vector2) -> void:
	# Convert the global screen touch to local coordinates inside the joystick node
	var local_pos = joystick.get_global_transform().affine_inverse() * touch_pos
	var offset = local_pos - center_point
	
	# Clamp the knob so it doesn't fly outside the base texture
	joystick_vector = offset.limit_length(max_distance) / max_distance
	knob.position = center_point + (joystick_vector * max_distance)
	
	_trigger_actions()

func _reset_joystick() -> void:
	active_touch_index = -1
	joystick_vector = Vector2.ZERO
	knob.position = center_point
	_trigger_actions()

func _trigger_actions() -> void:
	# Simulates physical keyboard presses for your player.gd script
	if joystick_vector.x < -deadzone:
		Input.action_press("move_left")
		Input.action_release("move_right")
	elif joystick_vector.x > deadzone:
		Input.action_press("move_right")
		Input.action_release("move_left")
	else:
		Input.action_release("move_left")
		Input.action_release("move_right")
