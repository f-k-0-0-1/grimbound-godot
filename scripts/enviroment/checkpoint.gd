extends Area2D

@export var activation_sound: String = "star_twinkle"
var is_active: bool = false

@onready var sprite : Sprite2D = $Sprite2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	sprite.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not is_active:
		is_active = true
	
		sprite.visible = true
		
		GameManager.current_checkpoint_position = global_position
		
		if AudioManager and AudioManager.has_method("play_sfx"):
			AudioManager.play_sfx(activation_sound)
			
		print("Checkpoint activated at: ", global_position)
