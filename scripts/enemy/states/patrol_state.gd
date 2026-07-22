extends State
class_name PatrolState

var enemy: EnemyBase
var move_direction: float = 1.0 # 1.0 is Right, -1.0 is Left

var wall_ray: RayCast2D
var ground_ray: RayCast2D

func enter() -> void:
	enemy = owner as EnemyBase
	
	enemy.z_index = 0
	
	wall_ray = enemy.get_node("WallRay")
	ground_ray = enemy.get_node("GroundRay")
	
	# SYNCHRONIZE DIRECTION: Make sure patrol direction matches sprite's current facing orientation!
	if enemy.sprite:
		if enemy.sprite.flip_h:
			move_direction = -1.0
		else:
			move_direction = 1.0
			
		# Ensure raycasts point in the correct matching direction
		_update_raycasts()
		
		if enemy.sprite.sprite_frames.has_animation("walk"):
			enemy.sprite.play("walk")

func physics_update(_delta: float) -> void:
	if not enemy or not enemy.stats:
		return

	# 1. Check if we are about to hit a wall OR fall off a ledge
	if wall_ray.is_colliding() or not ground_ray.is_colliding():
		_flip_direction()
		transitioned.emit(self, "idlestate")
		return 

	# 2. Move along the floor
	enemy.velocity.x = move_direction * enemy.stats.speed

func _flip_direction() -> void:
	move_direction *= -1.0
	
	if enemy.sprite:
		enemy.sprite.flip_h = move_direction < 0
		
	_update_raycasts()

func _update_raycasts() -> void:
	# Force raycasts to face the direction of movement so ledge/wall detection works instantly
	if wall_ray:
		wall_ray.target_position.x = abs(wall_ray.target_position.x) * move_direction
	if ground_ray:
		ground_ray.position.x = abs(ground_ray.position.x) * move_direction
