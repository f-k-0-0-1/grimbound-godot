# This Scripts Manages the Scenes
extends Node;

# PLS,PLS UPDATE THIS AFTER ADDING LEVELS @Faiq
const TOTAL_LEVELS: int = 1;
const DEFAULT_LEVLE_COLOR: Color = Color(0.501, 0.501, 0.501, 1.0)

# Local Variables
var scenes: Dictionary;
var current_level: int;

# Run Once
func _ready() -> void:
	# Setup the Scenes
	scenes = {
		"Hud": "res://Scenes/Hud.tscn",
		"level_1": "res://Scenes/TmpLevel.tscn"  # Just For Testing
	};
	
	# Set The Current Level (0 For No Loaded Level)
	current_level = 0; 

# Func Which Returns PackedScene
func init_Scene(scene_name:String) -> PackedScene:
	var temp_Init: PackedScene;
	
	# Check The Scene In The Dic
	if (scene_name in scenes):
		if (scenes[scene_name] == null):  				# If Scene Null Returns Null
			temp_Init = null;
		else:
			# Check If Scene Is A Level Or  A Prefab
			if (scene_name.begins_with("level_")):      							# Logic For Levels
				temp_Init = load(scenes[scene_name]);
				current_level = scene_name.replace("level_", "").to_int();  		# Extract The Level Number
				RenderingServer.set_default_clear_color(DEFAULT_LEVLE_COLOR); 	# Set The Level Color
				
			else:
				temp_Init = load(scenes[scene_name]);  	# For Prefabs
	
	# Return The Packed Scene
	return temp_Init;

# Function Which Returns the Game Hud
func initHud() -> CanvasLayer:
	var temp_Init: CanvasLayer;
	
	# Load the Hud 
	temp_Init = load(scenes["Hud"]).instantiate() as CanvasLayer;
	return temp_Init;
