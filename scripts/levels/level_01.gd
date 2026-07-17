## Level_01 - Simple level controller
extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var mobile_controls: CanvasLayer = $MobileControls

func _ready() -> void:
	print("Level_01: _ready START")
	
	# Make sure player is ready
	if player:
		print("Level_01: Player found")
	else:
		print("Level_01: Player NOT found")
	
	# Make sure mobile controls are ready
	if mobile_controls:
		print("Level_01: MobileControls found")
		mobile_controls.visible = true
	else:
		print("Level_01: MobileControls NOT found")
	
	print("Level_01: _ready END")

func _process(delta: float) -> void:
	# Optional: Add level-specific logic here
	pass
