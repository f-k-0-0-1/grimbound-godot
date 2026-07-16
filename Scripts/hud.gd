extends CanvasLayer

# Constants
const DOUBLE_TAB: int =  2;

# Local Variables
var tabL: int = 0;
var tabR: int = 0;
var player: PlayerData = Global.Default_Player;
var ButtonPressed: String;

func _physics_process(_delta: float) -> void:
	# Idle Animation
	if (player.body.is_on_floor() && !player.isMoving && !player.isJumping):
		player.Play("idle");

	print("------------")
	print(str(tabL) + " : " + str(tabR))
	print("------------")

	# Handle Jump Anim On Walking And Jumping Together
	if (player.body.is_on_floor() && player.isJumping):
		player.Jump("stop");
		player.isJumping = false;
		player.ContinueLast();
		
	# Player Movement
	match (ButtonPressed):
		"left":
			if (tabL >= DOUBLE_TAB):
				player.Move("left_run");
				player.Play("run");
			else:
				player.Move(ButtonPressed);
				player.Play("walk");
		"right":
			if (tabR >= DOUBLE_TAB):
				player.Move("right_run");
				player.Play("run");
			else:
				player.Move(ButtonPressed);
				player.Play("walk");
		"jump":
			if (player.body.is_on_floor()):
				player.Play("jump");
				player.Jump("start");
		"jump_stop":
			if (player.body.is_on_floor()):
				player.Jump("stop");
				player.isJumping = false;
				player.ContinueLast();
		"stop":
			player.Stop();

# Signal PLayer Left
func leftHold():
	tabL += 1;
	ButtonPressed = "left";
	
# Signal Player Right
func rightHold():
	tabR += 1;
	ButtonPressed = "right";

# Signal Stop Player
func leftStop():
	ButtonPressed = "stop"
	await get_tree().create_timer(0.1).timeout;
	if (!player.isRunnig):
		tabL = 0;
	
func rightStop():
	ButtonPressed = "stop"
	await get_tree().create_timer(0.1).timeout;
	if (!player.isRunnig):
		tabR = 0;
	
# Signal Jump
func JumpHold():
	ButtonPressed = "jump"
	
func JumpStop():
	ButtonPressed = "Jump_Stop"

# Signals For Back 
func BackPressed():
	# Pasue The Game 
	get_tree().paused = true;
	# Set Global Vars
	Global.Loaded_Once_InLevel = false;
	SceneManager.current_level = 0;
	SceneManager.setBG(Global.BLACK);
	
	# Switch To Main Screen After Last Frame
	get_tree().change_scene_to_packed.call_deferred(SceneManager.init_Scene("Main_Menu"));
