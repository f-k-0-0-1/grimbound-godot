# BluePrint For Players Data
extends RefCounted;
class_name PlayerData  # Make Object of This Class For New Players Data

# Constant
const PLAYER_SPEED = 2.6 * Global.SCALAR;  

# Player Variables
var speed: float = PLAYER_SPEED;
var run_speed: float = PLAYER_SPEED * 1.8;
var jump_speed: float = 3.0 * Global.SCALAR;
var body: CharacterBody2D = null;
var skin: AnimatedSprite2D = null;

# Booleans 
var isJumping: bool = false;
var isMoving: bool = false;
var isRunnig: bool = false;

# Increase The Player Speed
func Move(dir: String):
	# Set The Flag
	isMoving = true;
	
	# Match The Type
	match (dir):
		"left":
			body.velocity.x =  -(speed * Global.Physic_Time);
			skin.flip_h = true;    	# Flip The Sprite To Left
		"right":
			body.velocity.x = speed * Global.Physic_Time;
			skin.flip_h = false; 	# Flip The Sprite To Right
		"left_run":
			body.velocity.x =  -(run_speed * Global.Physic_Time);
			skin.flip_h = true;
			isRunnig = true;
		"right_run":
			body.velocity.x  = run_speed * Global.Physic_Time;
			skin.flip_h = false;
			isRunnig = true;

# Stop Player 
func Stop():
	isMoving = false;
	isRunnig = false;
	body.velocity.x = 0.0;

# Jump The Player
func Jump(type: String):
	# Set The Flag
	isJumping = true;
	
	# Match The Type
	match (type):
		"start":
			if (body.is_on_floor()):
				body.velocity.y = -(jump_speed * Global.Physic_Time);
				# TODO: Add Double Jump
		"stop":
			if (not body.is_on_floor()):
				pass # TODO: Make Hulk Jump 

# Animations Handle
func Play(anim: String):
	match anim:
		"idle":
			skin.play("Idle");
		"walk":
			skin.play("Walk");
		"jump":
			skin.play("Jump_Start");
		"run":
			skin.play("Run");

# Continue Last Animation
func ContinueLast():
	# Check If Moving 
	if (isMoving && !isRunnig):
		skin.play("Walk")
	elif (isRunnig):
		skin.play("Run");
	else:
		return;
