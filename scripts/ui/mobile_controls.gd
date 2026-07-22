extends CanvasLayer

# TouchScreenButton references
@onready var left_button: TouchScreenButton = $LeftContainer/LeftButton
@onready var right_button: TouchScreenButton = $RightContainer/RightButton
@onready var up_button: TouchScreenButton = $UpContainer/UpButton
@onready var down_button: TouchScreenButton = $DownContainer/DowntButton
@onready var jump_button: TouchScreenButton = $JumpContainer/JumpButton

func _ready() -> void:
	# Connect movement buttons
	left_button.pressed.connect(_on_left_pressed)
	left_button.released.connect(_on_left_released)
	
	right_button.pressed.connect(_on_right_pressed)
	right_button.released.connect(_on_right_released)
	
	up_button.pressed.connect(_on_up_pressed)
	up_button.released.connect(_on_up_released)
	
	down_button.pressed.connect(_on_down_pressed)
	down_button.released.connect(_on_down_released)
	
	jump_button.pressed.connect(_on_jump_pressed)
	jump_button.released.connect(_on_jump_released)
	

# Left Button
func _on_left_pressed() -> void:
	Input.action_press("move_left")

func _on_left_released() -> void:
	Input.action_release("move_left")

# Right Button
func _on_right_pressed() -> void:
	Input.action_press("move_right")

func _on_right_released() -> void:
	Input.action_release("move_right")

# Up Button
func _on_up_pressed() -> void:
	Input.action_press("move_up")

func _on_up_released() -> void:
	Input.action_release("move_up")

# Down Button
func _on_down_pressed() -> void:
	Input.action_press("move_down")

func _on_down_released() -> void:
	Input.action_release("move_down")

# Jump Button
func _on_jump_pressed() -> void:
	Input.action_press("jump")

func _on_jump_released() -> void:
	Input.action_release("jump")
