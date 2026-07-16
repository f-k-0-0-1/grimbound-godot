# Main Script Of Main Menu
extends Node

# Runs Once
func _ready() -> void:
	# When Main Menu Called From Levels
	if (get_tree().paused):
		get_tree().paused = false;

# Main Menu Buttons Signal Functions
func play():
	# Load Level 1 and Switch At Last Frame
	get_tree().change_scene_to_packed.call_deferred(SceneManager.init_Scene("level_1"));
	
func exit():
	# Exit On Last Frame
	get_tree().quit(0);
