# This Scripts Manages the Scenes
extends Node;

# PLS,PLS UPDATE THIS AFTER ADDING LEVELS @Faiq
const TOTAL_LEVELS: int = 1;

# Local Variables
var scenes: Dictionary;
var current_level: int;

# Run Once
func _ready() -> void:
	# Setup the Scenes
	scenes = {
		"Hud": "res://Scenes/Hud.tscn",
		"Main_Menu": "res://Scenes/Main_Menu.tscn",
		"level_1": "res://Scenes/Levels/Level_1.tscn",
		"level_2": "res://Scenes/Levels/TmpLevel.tscn"  	 # Just For Testing
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
			# Check If Scene Is A Level Or A Prefab
			if (scene_name.begins_with("level_")):      							# Logic For Levels
				temp_Init = load(scenes[scene_name]);
				current_level = scene_name.replace("level_", "").to_int();  		# Extract The Level Numberr
				setBG(Global.GRAY) 												# Set The Level Color
				
			else:
				temp_Init = load(scenes[scene_name]);  	# For Prefab

	
	# Return The Packed Scene
	return temp_Init;

# Function Which Returns the Game Hud
func initHud() -> CanvasLayer:
	var temp_Init: CanvasLayer;
	
	# Load the Hud 
	temp_Init = load(scenes["Hud"]).instantiate() as CanvasLayer;
	return temp_Init;

# Function To Set BackGround Color OF Scene
func setBG(color: Color):
	RenderingServer.set_default_clear_color(color);
