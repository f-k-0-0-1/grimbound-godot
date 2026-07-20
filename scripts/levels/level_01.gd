## Level_01 - Level controller with dynamic control scheme loader
extends Node2D

# Preload your control UI scenes
const JOYSTICK_CONTROLS_SCENE: PackedScene = preload("res://scenes/ui/joystick_controls.tscn")
const BUTTON_CONTROLS_SCENE: PackedScene = preload("res://scenes/ui/button_controls.tscn")

func _ready() -> void:
	# 1. Start background music with a smooth 2.0-second fade-in
	AudioManager.play_music("bg_music_2", 2.0) # Change track name as needed (e.g., "level_2" or "bg_music_2")
	
	# 2. Check the active control scheme saved by the player in Settings
	var active_scheme = SaveManager.load_control_scheme()
	
	# 3. Dynamically instantiate the correct control UI
	_spawn_controls(active_scheme)

func _spawn_controls(scheme: String) -> void:
	var control_instance: Node = null
	
	if scheme == "joystick":
		control_instance = JOYSTICK_CONTROLS_SCENE.instantiate()
		print("Level: Spawning Joystick Controls")
	else:
		control_instance = BUTTON_CONTROLS_SCENE.instantiate()
		print("Level: Spawning Button Controls")
		
	# Add the chosen controls directly to the active scene tree root
	if control_instance:
		add_child(control_instance)
