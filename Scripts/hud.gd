extends CanvasLayer

# Move The PLayer Left
func leftHold():
	Global.Default_Player.Move("left");

# Move The Player Right
func rightHold():
	Global.Default_Player.Move("right");

# Functions to Stop Player
func leftStop():
	Global.Default_Player.Stop();

func rightStop():
	Global.Default_Player.Stop();

# Functions For Jump
func JumpHold():
	Global.Default_Player.Jump();
