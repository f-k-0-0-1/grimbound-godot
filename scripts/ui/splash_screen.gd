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
var is_Waiting: bool;
var has_transitioned: bool = false;  # Prevent multiple transitions

# Run Once
func _ready() -> void:
	# Defaults
	is_Waiting = false;
	
	# Set The Bg Color In Splash Black
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1));
	
	# Cached The Label
	log_t = RichTextLabel.new();
	
	# Set the Alpha to zero
	cached_alpha = 0.0;
	orgName.modulate.a = cached_alpha;

# Run Always
func _process(delta: float) -> void:
	# If Timer In Waiting Do Nothing 
	if (is_Waiting):
		return;
	
	# Prevent multiple transitions
	if (has_transitioned):
		return;
	
	# Increase the Alpha Slowly
	cached_alpha += 0.1 * delta * Visible_Speed; 
	orgName.modulate.a = cached_alpha;

	# If Alpha Max Out Change to Main Menu
	if (cached_alpha > MAX_VISIBLE):
		has_transitioned = true
		
		# Transition to main menu
		if (SceneManager.has_method("go_to_menu")):
			SceneManager.go_to_menu()
		else:
			# Fallback: direct scene load
			var error = get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
			if error != OK:
				_show_error_and_quit("Main Menu Scene Not Found!")

# Show error and quit
func _show_error_and_quit(error_message: String) -> void:
	is_Waiting = true
	
	log_t.bbcode_enabled = true
	log_t.text = "[color=Red]Error:[/color] " + error_message
	log_t.modulate.a = 0.8
	log_t.custom_minimum_size = Vector2(200, 20)
	log_t.add_theme_font_size_override("normal_font_size", 12)
	log_t.fit_content = true
	log_t.scroll_active = false
	
	add_child(log_t)
	log_t.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	log_t.grow_vertical = Control.GROW_DIRECTION_BEGIN
	log_t.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	
	await get_tree().create_timer(Exit_Wait_Time).timeout
	get_tree().quit(ERROR)
