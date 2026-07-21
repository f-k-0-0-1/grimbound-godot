extends State
class_name IdleState

@export var idle_time: float = 2.0 # How long to stand still
var timer: float = 0.0
var enemy: EnemyBase

func enter() -> void:
	# 1. Get the enemy body
	enemy = owner as EnemyBase
	
	# 2. Stop all horizontal movement
	enemy.velocity.x = 0
	
	# 3. PLAY THE ANIMATION
	if enemy.sprite and enemy.sprite.sprite_frames.has_animation("idle"):
		enemy.sprite.play("idle")
		
	# 4. Reset our wait timer
	timer = idle_time

func physics_update(delta: float) -> void:
	# Count down the timer
	timer -= delta
	
	# When time is up, tell the brain to switch back to patrolling!
	if timer <= 0.0:
		transitioned.emit(self, "patrolstate")
