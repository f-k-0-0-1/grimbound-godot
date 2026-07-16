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
	SceneManager.setBG(Global.BLACK);
	
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
		# Change Scene To Main Menu
		var main_menu: PackedScene = SceneManager.init_Scene("Main_Menu");
		if (main_menu != null):
			get_tree().change_scene_to_packed(main_menu);
			return;
		else:
			# Set The Wating
			is_Wating = true;
			
			# Handle NUll
			log_t.bbcode_enabled = true;
			
			# [AI Help] Color in RichTextLable
			log_t.text = "[color=Red]Log:[/color] Main Scene Null !";
			
			# Tweaks
			log_t.modulate.a = 0.8;
			log_t.custom_minimum_size = Vector2(200, 20);
			log_t.add_theme_font_size_override("normal_font_size", 12);
			log_t.fit_content = true;
			log_t.scroll_active = false;
			
			# Add To The Tree
			add_child(log_t);
			
			# [AI Help] Grow Inwords
			log_t.grow_horizontal = Control.GROW_DIRECTION_BEGIN
			log_t.grow_vertical = Control.GROW_DIRECTION_BEGIN
			
			# Set Ancors
			log_t.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT);
			
			# Wait for Seconds Before Quit, 
			await get_tree().create_timer(Exit_Wait_Time + 10).timeout;
			
			# Then Exit With Exit Code
			get_tree().quit(ERROR);
