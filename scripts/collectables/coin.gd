extends RigidBody2D
class_name Coin

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collection_area: Area2D = $CollectionArea

var collected: bool = false
var is_airborne: bool = false

func _ready() -> void:
	if animated_sprite and animated_sprite.sprite_frames.has_animation("play"):
		animated_sprite.play("play")
	
	if collection_area:
		collection_area.body_entered.connect(_on_player_entered)

# Called by DeathState to launch coins outward into the air
func apply_launch_impulse(initial_velocity: Vector2) -> void:
	linear_velocity = initial_velocity
	is_airborne = true
	
	# Temporarily reduce gravity scale so they hang in the air like a fountain burst!
	gravity_scale = 0.2 
	
	# After 0.3 seconds, restore full gravity so they fall back down to the ground
	await get_tree().create_timer(0.3).timeout
	if not collected and is_instance_valid(self):
		gravity_scale = 1.0
		is_airborne = false

func _on_player_entered(body: Node2D) -> void:
	if collected:
		return
		
	if body.is_in_group("Player"):
		collected = true
		
		set_deferred("freeze", true)
		if has_node("CollisionShape2D"):
			$CollisionShape2D.set_deferred("disabled", true)
		if collection_area and collection_area.has_node("CollisionShape2D"):
			$CollectionArea/CollisionShape2D.set_deferred("disabled", true)
			
		if animated_sprite:
			animated_sprite.visible = false
			
		GameManager.add_coin(1)
		AudioManager.play_sfx("coin", 0.0, -10.0)
		
		await get_tree().create_timer(0.5).timeout
		queue_free()
