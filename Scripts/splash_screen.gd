extends Node

# Lazy Load
@onready var orgName: Label = $Label;

# Exported to Inspector
@export var Visible_Speed: float = 0.5;

# Constants
const MAX_VISIBLE: float = 1.0;

# Local Vars
var cached_alpha: float;

# Run Once
func _ready() -> void:
	# Set the Alpha to zero
	cached_alpha = 0.0;
	orgName.modulate.a = cached_alpha;

# Run Always
func _process(delta: float) -> void:
	
	# Increase the Alpha Slowely
	cached_alpha += 0.1 * delta * Visible_Speed; 
	orgName.modulate.a = cached_alpha;

	# If Alpha Max Out Change to Main Menu
	if (cached_alpha > MAX_VISIBLE):
		# Change Screen Here
		pass
