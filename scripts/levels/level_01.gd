## Level_01 - Level controller with dynamic control scheme loader & live refresh
extends Node2D

# Preload your control UI scenes
const JOYSTICK_CONTROLS_SCENE: PackedScene = preload("res://scenes/ui/joystick_controls.tscn")
const BUTTON_CONTROLS_SCENE: PackedScene = preload("res://scenes/ui/button_controls.tscn")

# Reference to track the currently active control instance in the scene tree
var current_control_instance: Node = null

func _ready() -> void:
	# 1. Start background music with a smooth 2.0-second fade-in
	AudioManager.play_music("bg_music_2", 2.0)
	
	# 2. Listen to the global control scheme change signal from GameManager
	if GameManager.has_signal("control_scheme_changed"):
		GameManager.control_scheme_changed.connect(_on_control_scheme_changed)
	
	# 3. Check saved scheme and spawn initial controls
	var active_scheme = SaveManager.load_control_scheme()
	_spawn_controls(active_scheme)

func _spawn_controls(scheme: String) -> void:
	# If controls already exist (e.g. during a live switch), clear them out first
	if current_control_instance and is_instance_valid(current_control_instance):
		current_control_instance.queue_free()
		current_control_instance = null
	
	if scheme == "joystick":
		current_control_instance = JOYSTICK_CONTROLS_SCENE.instantiate()
		print("Level: Spawning Joystick Controls")
	else:
		current_control_instance = BUTTON_CONTROLS_SCENE.instantiate()
		print("Level: Spawning Button Controls")
		
	# Add the chosen controls directly to the active scene tree root
	if current_control_instance:
		add_child(current_control_instance)

# --- LIVE REFRESH LISTENER ---
func _on_control_scheme_changed(new_scheme: String) -> void:
	# Instantly called when settings toggles a new scheme from the pause menu
	_spawn_controls(new_scheme)
