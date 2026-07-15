extends CanvasLayer

# TouchScreenButton references
@onready var left_button: TouchScreenButton = $LeftContainer/LeftButton
@onready var right_button: TouchScreenButton = $RightContainer/RightButton
@onready var jump_button: TouchScreenButton = $JumpContainer/JumpButton
@onready var back_button: TouchScreenButton = $BackButton/TouchScreenButton

func _ready() -> void:
	# Connect movement buttons
	left_button.pressed.connect(_on_left_pressed)
	left_button.released.connect(_on_left_released)
	
	right_button.pressed.connect(_on_right_pressed)
	right_button.released.connect(_on_right_released)
	
	jump_button.pressed.connect(_on_jump_pressed)
	jump_button.released.connect(_on_jump_released)
	
	# Connect back button
	back_button.pressed.connect(_on_back_pressed)

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

# Jump Button
func _on_jump_pressed() -> void:
	Input.action_press("jump")

func _on_jump_released() -> void:
	Input.action_release("jump")

# Back Button
func _on_back_pressed() -> void:
	# Go back to main menu
	if SceneManager and SceneManager.has_method("go_to_menu"):
		SceneManager.go_to_menu()
	else:
		# Fallback: direct load
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
