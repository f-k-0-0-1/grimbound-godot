## SceneManager - Handles all scene transitions and flow (Async Architecture)
extends Node

# Scene constants
const SCENE_SPLASH: String = "res://scenes/ui/Splash_Screen.tscn"
const SCENE_MENU: String = "res://scenes/ui/main_menu.tscn"
const SCENE_LEVEL_01: String = "res://scenes/levels/level_01.tscn"
const SCENE_LOADING: String = "res://scenes/ui/loading_screen.tscn"
const SCENE_SETTINGS: String = "res://scenes/ui/settings.tscn"

# Current scene reference
var current_scene: Node = null
var is_transitioning: bool = false

# NEW: Holds the path for the loading screen to pick up and process in the background
var target_level_path: String = "" 

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func load_scene(scene_path: String) -> void:
	if is_transitioning:
		print("SceneManager: Already transitioning, ignoring request")
		return
	
	is_transitioning = true
	print("SceneManager: Preparing async load for:", scene_path)
	
	# Check if file exists
	if not ResourceLoader.exists(scene_path):
		push_error("SceneManager: Scene not found:", scene_path)
		is_transitioning = false
		return
	
	# 1. Store the target path globally so the loading screen can access it
	target_level_path = scene_path
	
	# 2. Instantly switch to the lightweight loading screen to flush heavy assets from RAM
	var error = get_tree().change_scene_to_file(SCENE_LOADING)
	
	if error != OK:
		push_error("SceneManager: Failed to load loading screen scene!")
		is_transitioning = false
		return
	
	await get_tree().process_frame
	current_scene = get_tree().current_scene
	is_transitioning = false
	print("SceneManager: Successfully transitioned to loading screen.")

func go_to_splash() -> void:
	load_scene(SCENE_SPLASH)

func go_to_menu() -> void:
	load_scene(SCENE_MENU)

func go_to_level_01() -> void:
	load_scene(SCENE_LEVEL_01)

func go_to_settings() -> void:
	load_scene(SCENE_SETTINGS)

func go_to_level(level_name: String) -> void:
	var level_path = "res://scenes/levels/" + level_name + ".tscn"
	load_scene(level_path)

func reload_current_scene() -> void:
	if current_scene and current_scene.scene_file_path:
		load_scene(current_scene.scene_file_path)

func quit_game() -> void:
	get_tree().quit()

func get_current_scene_name() -> String:
	if current_scene and current_scene.scene_file_path:
		return current_scene.scene_file_path.get_file().get_basename()
	return "unknown"
