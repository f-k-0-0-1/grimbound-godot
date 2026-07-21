extends State
class_name PatrolState

# We will grab a reference to our main enemy body so we can move it
var enemy: EnemyBase
var move_direction: float = 1.0 # 1.0 is Right, -1.0 is Left

# We cache our RayCasts so we don't have to search for them every frame
var wall_ray: RayCast2D
var ground_ray: RayCast2D

func enter() -> void:
	# 'owner' gets the root node of the saved scene (EnemyBase)
	enemy = owner as EnemyBase
	
	wall_ray = enemy.get_node("WallRay")
	ground_ray = enemy.get_node("GroundRay")
	
	# Play the walking animation if it exists
	if enemy.sprite and enemy.sprite.sprite_frames.has_animation("walk"):
		enemy.sprite.play("walk")

func physics_update(_delta: float) -> void:
	if not enemy or not enemy.stats:
		return

	# 1. Check if we are about to hit a wall OR fall off a ledge
	if wall_ray.is_colliding() or not ground_ray.is_colliding():
		# Flip the internal direction
		_flip_direction()
		# Tell the StateMachine to switch to the IdleState to wait!
		transitioned.emit(self, "idlestate")
		return # Stop executing this frame so we don't move forward

	# 2. Set the velocity using the data from Pillar 1 (EnemyStats)
	enemy.velocity.x = move_direction * enemy.stats.speed
	
	# Note: We do NOT call move_and_slide() here. 
	# EnemyBase._physics_process() handles gravity and move_and_slide() for us!

func _flip_direction() -> void:
	move_direction *= -1.0
	
	# Flip the sprite visually
	if enemy.sprite:
		enemy.sprite.flip_h = move_direction < 0
		
	# Flip the RayCasts so they point in the new direction
	# Assuming WallRay normally points Right (e.g., X = 20)
	wall_ray.target_position.x = abs(wall_ray.target_position.x) * move_direction
	
	# Move the GroundRay to the front of the enemy so it looks ahead
	ground_ray.position.x = abs(ground_ray.position.x) * move_direction
