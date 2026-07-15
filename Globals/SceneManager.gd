# This Scripts Manages the Scenes
extends Node;

# Local Variables
var scenes: Dictionary;

# Run Once
func _ready() -> void:
	# Setup the Scenes
	scenes = {
		"main": null
	};

# Func Which Returns PackedScene
func init_Scene(scene_name:String) -> PackedScene:
	var temp_Int: PackedScene;
	
	# Check The Scene In The Dic
	if (scene_name in scenes):
		if (scenes[scene_name] == null):
			temp_Int = null
		else:
			# TODO Faiq: Init the Scene Here
			pass;
	# Return The Packed Scene
	return temp_Int;
