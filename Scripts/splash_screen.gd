extends Node

# Lazy Load
@onready var orgName: Label = $Label;

# Exported to Inspector
@export var Visible_Speed: float = 0.5;
@export var Exit_Wait_Time: float = 10;

# Constants
const ERROR: int = 1;
const MAX_VISIBLE: float = 1.0;

# Local Vars
var cached_alpha: float;
var log_t: RichTextLabel;
var is_Wating: bool;

# Run Once
func _ready() -> void:
	# Defaults
	is_Wating = false;
	
	# Set The Bg Color In Splash Black
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1));
	
	# Cahced The Label
	log_t = RichTextLabel.new();
	
	# Set the Alpha to zero
	cached_alpha = 0.0;
	orgName.modulate.a = cached_alpha;

# Run Always
func _process(delta: float) -> void:
	# If Timer In Waiting Do Nothing 
	if (is_Wating):
		return;
	
	# Increase the Alpha Slowely
	cached_alpha += 0.1 * delta * Visible_Speed; 
	orgName.modulate.a = cached_alpha;

	# If Alpha Max Out Change to Main Menu
	if (cached_alpha > MAX_VISIBLE):
		# Change Screen Here
		if (SceneManager.init_Scene("main") != null):
			# TODO Faiq: Change To The PackedScene Of Main Menu
			pass;
		else:
			# Set The Wating
			is_Wating = true;
			
			# Handle NUll
			log_t.bbcode_enabled = true;
			
			# [Asked Form AI: Question: How to Apply Color in String"
			log_t.text = "[color=yellow]Log:[/color] Main Scene Null !";
			
			# Pin The Log Lable To The Top Left
			log_t.anchor_right = 1.0;
			log_t.anchor_bottom = 1.0;
			
			# Add To The Tree
			add_child(log_t);
			
			# Wait for Seconds Before Quit
			await get_tree().create_timer(Exit_Wait_Time).timeout;
			
			# Then Exit With Exit Code
			get_tree().quit(ERROR);
