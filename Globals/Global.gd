# This Script Stores And Init All Global Variables
extends Node

# Constants
const SCALAR: float = 10000.0;
const BLACK: Color = Color(0.0, 0.0, 0.0, 1.0);
const GRAY: Color = Color(0.501, 0.501, 0.501, 1.0)

# Declarations
var Gravity_Power: float;
var Hud: CanvasLayer;
var Default_Player: PlayerData;
var Physic_Time: float;

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
	# Get The Physics Delta Time
	Physic_Time = get_tree().root.get_physics_process_delta_time();
	
	# Load The Things Related To Levels
	if (SceneManager.current_level != 0):
		# Things To Load Onces
		if (not Loaded_Once_InLevel and get_tree().current_scene != null):
			# Load The Hud Once
			Hud = SceneManager.initHud();
			get_tree().current_scene.add_child(Hud); 		# Add the Hud In Scene 
			print("Hud: Loaded!");
	
			# Set The Default Player Scene And Skin
			Default_Player.body = get_tree().get_first_node_in_group("player");
			Default_Player.skin = Default_Player.body.get_node("Skin");
		
			# Set Loaded Once To True
			Loaded_Once_InLevel = true;
