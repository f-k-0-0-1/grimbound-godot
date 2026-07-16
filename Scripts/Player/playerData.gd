# BluePrint For Players Data
extends RefCounted
class_name PlayerData  # Make Object of This Class For New Players Data

# Player Variables
var speed: float = 600;
var jump_speed: float = 500;
var scene: CharacterBody2D = null;

# Increase The Player Speed
func Move(dir: String):
	if (dir == "left"):
		scene.velocity.x -= speed;
	else:
		scene.velocity.x += speed;
# Stop Player 
func Stop():
	scene.velocity.x = 0.0;

# Jump The Player
func Jump():
	scene.velocity.y -= jump_speed;
