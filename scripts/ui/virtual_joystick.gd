extends CanvasLayer

# --- LEFT JOYSTICK NODES ---
@onready var left_zone: Control = $LeftTouchZone
@onready var base: TextureRect = $LeftTouchZone/Base
@onready var tip: TextureRect = $LeftTouchZone/Base/Tip
@onready var swipe_tutorial: Label = $RightJumpZone/SwipeTutorial

# --- RIGHT ZONE NODES ---
@onready var right_zone: Control = $RightJumpZone
@onready var attack_button: TouchScreenButton = $Control/AttackButton
@onready var fireball_button: TouchScreenButton = $Control2/FireballButton

# --- LEFT STICK VARIABLES ---
var max_radius: float = 0.0
var move_touch_index: int = -1
var is_dragging_stick: bool = false
var output_vector: Vector2 = Vector2.ZERO

# --- RIGHT SWIPE VARIABLES ---
var jump_touch_index: int = -1
var jump_start_y: float = 0.0
var jump_peak_y: float = 0.0
var jump_state: int = 0 # 0=Idle, 1=Resetting, 2=Ready for Jump 2, 3=Exhausted

@export var swipe_jump_threshold: float = 50.0  # Pixels you must swipe UP to trigger a jump
@export var swipe_reset_threshold: float = 20.0 # Pixels you must pull DOWN to reset for double jump

func _ready() -> void:
	if swipe_tutorial:
		swipe_tutorial.visible = true
	if base:
		max_radius = base.size.x / 2.0
	_reset_joystick()

	# Connect TouchScreenButton signals safely
	if attack_button:
		attack_button.pressed.connect(_on_attack_pressed)
		attack_button.released.connect(_on_attack_released)

	if fireball_button:
		fireball_button.pressed.connect(_on_fireball_pressed)
		fireball_button.released.connect(_on_fireball_released)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			# 1. LEFT THUMB (Movement & Climbing)
			if left_zone and left_zone.get_global_rect().has_point(event.position) and not is_dragging_stick:
				is_dragging_stick = true
				move_touch_index = event.index
				_update_joystick(event.position)
				
			# 2. RIGHT THUMB (Jumping - swipe zone)
			elif right_zone and right_zone.get_global_rect().has_point(event.position) and jump_touch_index == -1:
				jump_touch_index = event.index
				jump_start_y = event.position.y
				jump_state = 0 # Reset jump state machine
				
		elif not event.pressed:
			# Left thumb lifted
			if event.index == move_touch_index:
				is_dragging_stick = false
				move_touch_index = -1
				_reset_joystick()
			# Right thumb lifted
			elif event.index == jump_touch_index:
				jump_touch_index = -1
				Input.action_release("jump")
				jump_state = 0

	elif event is InputEventScreenDrag:
		# Process Left Drag
		if is_dragging_stick and event.index == move_touch_index:
			_update_joystick(event.position)
			
		# Process Right Drag
		elif event.index == jump_touch_index:
			_handle_jump_swipe(event.position.y)

# --- ATTACK BUTTON HANDLERS ---
func _on_attack_pressed() -> void:
	Input.action_press("attack")

func _on_attack_released() -> void:
	Input.action_release("attack")

# --- FIREBALL BUTTON HANDLERS ---
func _on_fireball_pressed() -> void:
	Input.action_press("fireball") # Make sure "fireball" or "shoot" matches your Input Map

func _on_fireball_released() -> void:
	Input.action_release("fireball")

# --- RIGHT ZONE JUMP LOGIC ---
func _handle_jump_swipe(current_y: float) -> void:
	var distance_swiped_up = jump_start_y - current_y # Positive means moving UP
	if swipe_tutorial:
		swipe_tutorial.visible = false
	
	# STATE 0: Waiting for the first jump
	if jump_state == 0 and distance_swiped_up > swipe_jump_threshold:
		Input.action_press("jump")
		jump_state = 1
		jump_peak_y = current_y
		
	# STATE 1: Waiting for player to pull thumb down slightly to reset mechanism
	elif jump_state == 1:
		if current_y < jump_peak_y:
			jump_peak_y = current_y 
			
		if current_y > jump_peak_y + swipe_reset_threshold:
			Input.action_release("jump") 
			jump_state = 2
			jump_start_y = current_y 
			
	# STATE 2: Waiting for the second upward flick (Double Jump)
	elif jump_state == 2 and (jump_start_y - current_y) > swipe_jump_threshold:
		Input.action_press("jump")
		jump_state = 3 

# --- LEFT ZONE MOVEMENT LOGIC ---
func _update_joystick(touch_pos: Vector2) -> void:
	if not base or not tip: return
	var center_of_base = base.global_position + (base.size / 2.0)
	var direction = touch_pos - center_of_base
	
	if abs(direction.x) > abs(direction.y):
		direction.y = 0.0 
	else:
		direction.x = 0.0 
	
	if direction.length() > max_radius:
		direction = direction.normalized() * max_radius
		
	tip.global_position = center_of_base + direction - (tip.size / 2.0)
	output_vector = direction / max_radius
	
	# X-AXIS (Running)
	if output_vector.x > 0.1: 
		Input.action_press("move_right", output_vector.x)
		Input.action_release("move_left")
	elif output_vector.x < -0.1:
		Input.action_press("move_left", abs(output_vector.x))
		Input.action_release("move_right")
	else:
		Input.action_release("move_right")
		Input.action_release("move_left")

	# Y-AXIS (Climbing Ladders)
	if output_vector.y < -0.1:
		Input.action_press("move_up", abs(output_vector.y))
		Input.action_release("move_down")
	elif output_vector.y > 0.1:
		Input.action_press("move_down", output_vector.y)
		Input.action_release("move_up")
	else:
		Input.action_release("move_up")
		Input.action_release("move_down")

func _reset_joystick() -> void:
	if base and tip:
		var center_of_base = base.global_position + (base.size / 2.0)
		tip.global_position = center_of_base - (tip.size / 2.0)
	output_vector = Vector2.ZERO
	
	Input.action_release("move_right")
	Input.action_release("move_left")
	Input.action_release("move_up")
	Input.action_release("move_down")
