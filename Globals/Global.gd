# This Script Stores And Init All Global Variables
extends Node

# Declarations
var Gravity_Power: float;
var Hud: CanvasLayer;
var Default_Player: PlayerData;

# Booleans 
var Loaded_Once_InLevel: bool;

# Runs Ones
func _ready() -> void:
	# Defaults
	Gravity_Power = 900;
	Loaded_Once_InLevel = false;
	
	# Load The Default Player Data
	Default_Player = PlayerData.new();
	
# Runs Always
func _process(_delta) -> void:
	# Load The Things Related To Levels
	if (SceneManager.current_level != 0):
		# Things To Load Onces
		if (not Loaded_Once_InLevel):
			# Load The Hud Once
			Hud = SceneManager.initHud();
			get_tree().current_scene.add_child(Hud); 		# Add the Hud In Scene 
	
			# Set The Default Player Scene
			Default_Player.scene = get_tree().get_first_node_in_group("player");
		
		# Set Load Once To True
		Loaded_Once_InLevel = true;
