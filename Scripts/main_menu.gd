## MainMenu - Menu controller for play and quit functionality
extends CanvasLayer

# Button references
@onready var play_button: Button = $Buttons/VBoxContainer/PlayButton
@onready var quit_button: Button = $Buttons/VBoxContainer/QuitButton

func _ready() -> void:
	# Connect button signals
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	

func _on_play_pressed() -> void:
	# Play click feedback
	_animate_button(play_button)
	
	# Load level 01 using SceneManager
	SceneManager.go_to_level_01()

func _on_quit_pressed() -> void:
	# Play click feedback
	_animate_button(quit_button)
	
	# Quit the game
	SceneManager.quit_game()

func _animate_button(button: Button) -> void:
	# Simple scale animation for button press feedback
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(button, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1)
