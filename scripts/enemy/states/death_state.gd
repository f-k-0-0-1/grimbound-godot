extends State
class_name DeathState

var enemy: EnemyBase
var coin_scene: PackedScene = preload("res://scenes/collectables/coin.tscn") # Adjust path if needed

func enter() -> void:
	enemy = owner as EnemyBase
	enemy.velocity = Vector2.ZERO
	
	# Disable all collisions and hurtboxes so it's a dead corpse
	for child in enemy.find_children("*", "Area2D"):
		child.queue_free()
	for child in enemy.find_children("*", "CollisionShape2D"):
		child.disabled = true
		
	# Play death animation
	if enemy.sprite and enemy.sprite.sprite_frames.has_animation("dying"):
		enemy.sprite.play("dying")
		
	# Drop a coin reward
	_spawn_coin()
	
	# Wait for the death animation to finish, then delete the goblin node
	if enemy.sprite:
		await enemy.sprite.animation_finished
	
	enemy.queue_free()

func _spawn_coin() -> void:
	if coin_scene:
		var coin = coin_scene.instantiate()
		coin.global_position = enemy.global_position
		enemy.get_parent().call_deferred("add_child", coin)
