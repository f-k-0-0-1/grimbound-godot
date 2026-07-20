extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# Start the 10-frame spinning animation immediately
	animated_sprite.play("play")
	
	# Connect signals via code to avoid editor UI clutter
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	# Ensure only the player can collect the coin
	if body.is_in_group("Player"):
		# 1. Disable the collision box so it can't be collected twice
		set_deferred("monitoring", false)
		
		# 2. Hide the graphic
		animated_sprite.visible = false
		
		# 3. Add to the global counter
		GameManager.add_coin(1)
		
		# 4. Play the sound effect
		AudioManager.play_sfx("coin", 0.0, -10.0)

func _on_sound_finished() -> void:
	# Safely delete the coin from the level only AFTER the sound finishes
	queue_free()
