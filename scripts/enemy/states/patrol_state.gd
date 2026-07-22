extends State
class_name PatrolState

var enemy: EnemyBase
var move_direction: float = 1.0
var wall_ray: RayCast2D
var ground_ray: RayCast2D

func enter() -> void:
	enemy = owner as EnemyBase
	wall_ray = enemy.get_node("WallRay")
	ground_ray = enemy.get_node("GroundRay")
	
	if enemy.sprite and enemy.sprite.sprite_frames.has_animation("walk"):
		enemy.sprite.play("walk")

func physics_update(_delta: float) -> void:
	if not enemy or not enemy.stats:
		return

	if wall_ray.is_colliding() or not ground_ray.is_colliding():
		_flip_direction()
		transitioned.emit(self, "idlestate")
		return

	enemy.velocity.x = move_direction * enemy.stats.speed

func _flip_direction() -> void:
	move_direction *= -1.0
	
	if enemy.sprite:
		enemy.sprite.flip_h = move_direction < 0
	
	# ✅ Flip the hitbox
	if enemy.has_method("flip_hitbox"):
		enemy.flip_hitbox(move_direction)
	
	wall_ray.target_position.x = abs(wall_ray.target_position.x) * move_direction
	ground_ray.position.x = abs(ground_ray.position.x) * move_direction
