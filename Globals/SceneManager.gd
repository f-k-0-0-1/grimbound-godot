## SceneManager - Handles all scene transitions and flow
extends Node

# Scene constants
const SCENE_SPLASH: String = "res://scenes/Splash_Screen.tscn"
const SCENE_MENU: String = "res://scenes/main_menu.tscn"
const SCENE_LEVEL_01: String = "res://scenes/levels/level_01.tscn"

# Current scene reference
var current_scene: Node = null
var is_transitioning: bool = false

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func load_scene(scene_path: String) -> void:
	if is_transitioning:
		print("SceneManager: Already transitioning, ignoring request")
		return
	
	is_transitioning = true
	print("SceneManager: Loading scene:", scene_path)
	
	# Check if file exists
	if not ResourceLoader.exists(scene_path):
		push_error("SceneManager: Scene not found:", scene_path)
		is_transitioning = false
		return
	
	var error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("SceneManager: Failed to load scene:", scene_path)
		is_transitioning = false
		return
	
	await get_tree().process_frame
	current_scene = get_tree().current_scene
	is_transitioning = false
	print("SceneManager: Scene loaded successfully")

func go_to_splash() -> void:
	load_scene(SCENE_SPLASH)

func go_to_menu() -> void:
	load_scene(SCENE_MENU)

func go_to_level_01() -> void:
	load_scene(SCENE_LEVEL_01)

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
