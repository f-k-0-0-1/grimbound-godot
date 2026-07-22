extends State
class_name DeathState

var enemy: EnemyBase
var coin_scene: PackedScene = preload("res://scenes/collectables/coin.tscn")

@export var min_coins: int = 3
@export var max_coins: int = 5

func enter() -> void:
	enemy = owner as EnemyBase
	enemy.velocity = Vector2.ZERO
	
	call_deferred("_disable_collisions_and_cleanup")

func _disable_collisions_and_cleanup() -> void:
	if not enemy:
		return
		
	for child in enemy.find_children("*", "Area2D"):
		child.queue_free()
		
	for child in enemy.find_children("*", "CollisionShape2D"):
		child.disabled = true
		
	if enemy.sprite and enemy.sprite.sprite_frames.has_animation("death"):
		enemy.sprite.play("death")
		
	_spawn_coins()
	
	if enemy.sprite and enemy.sprite.sprite_frames.has_animation("death"):
		await enemy.sprite.animation_finished
	
	enemy.queue_free()

func _spawn_coins() -> void:
	if not coin_scene:
		return
		
	var coin_count = randi_range(min_coins, max_coins)
	
	for i in range(coin_count):
		var coin = coin_scene.instantiate() as RigidBody2D
		
		# Spawn right at the goblin's chest
		coin.global_position = enemy.global_position + Vector2(0, -15)
		
		enemy.get_parent().call_deferred("add_child", coin)
		
		# Stronger upward arc and wider horizontal spread
		var random_velocity = Vector2(
			randf_range(-250.0, 250.0), # Wider side-to-side scatter
			randf_range(-450.0, -250.0) # Higher upward pop into the air
		)
		
		if coin.has_method("apply_launch_impulse"):
			coin.call_deferred("apply_launch_impulse", random_velocity)
