# Main Script Of Player
extends CharacterBody2D;

# Runs Physics Every Frame
func _physics_process(_delta: float) -> void:
	
	# Apply Gravity On Player
	if (not self.is_on_floor()):
		self.velocity.y += Global.Gravity_Power * _delta;
	
	# Call Class Movement Method
	self.move_and_slide();
