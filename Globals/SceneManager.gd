## SceneManager - Handles all scene transitions and flow
extends Node

# Scene constants
const SCENE_SPLASH: String = "res://Scenes/Splash_Screen.tscn"
const SCENE_MENU: String = "res://Scenes/main_menu.tscn"
const SCENE_LEVEL_01: String = "res://Scenes/Levels/level_01.tscn"

# Current scene reference
var current_scene: Node = null

# Called when the SceneManager is autoloaded
func _ready() -> void:
	# Get the current scene (splash screen)
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

## Load any scene by path
func load_scene(scene_path: String) -> void:
	var error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("Failed to load scene: ", scene_path)
		return
	
	# Update current scene reference
	await get_tree().process_frame
	current_scene = get_tree().current_scene

## Go to splash screen
func go_to_splash() -> void:
	load_scene(SCENE_SPLASH)

## Go to main menu
func go_to_menu() -> void:
	load_scene(SCENE_MENU)

## Go to level 01
func go_to_level_01() -> void:
	load_scene(SCENE_LEVEL_01)

## Go to any level by name
func go_to_level(level_name: String) -> void:
	var level_path = "res://Scenes/Levels/" + level_name + ".tscn"
	load_scene(level_path)

## Reload current scene
func reload_current_scene() -> void:
	if current_scene and current_scene.scene_file_path:
		load_scene(current_scene.scene_file_path)

## Quit the game
func quit_game() -> void:
	get_tree().quit()

## Get current scene name
func get_current_scene_name() -> String:
	if current_scene and current_scene.scene_file_path:
		return current_scene.scene_file_path.get_file().get_basename()
	return "unknown"
