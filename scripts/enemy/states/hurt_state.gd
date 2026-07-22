extends State
class_name HurtState

var enemy: EnemyBase
@export var knockback_friction: float = 1200.0 # How fast they stop sliding
@export var stun_duration: float = 0.4 # Minimum time the goblin stays hurt!

var current_stun_time: float = 0.0

func enter() -> void:
	enemy = owner as EnemyBase
	
	# Reset the stun timer every time we get hit
	current_stun_time = stun_duration
	
	# Play the hurt animation
	if enemy.sprite and enemy.sprite.sprite_frames.has_animation("hurt"):
		enemy.sprite.play("hurt")
		enemy.sprite.modulate = Color(2.238, 0.0, 0.0, 1.0) # Flash Red fallback
	else:
		enemy.sprite.modulate = Color(1, 0, 0) # Flash Red fallback

func physics_update(delta: float) -> void:
	# 1. Count down the stun timer
	current_stun_time -= delta
	
	# 2. Apply friction to stop the physical slide
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, knockback_friction * delta)
	
	if not enemy.is_on_floor():
		enemy.velocity.x = 0
		
	# 3. EXIT CONDITION: We must wait for BOTH the slide to stop AND the timer to finish
	if current_stun_time <= 0.0 and abs(enemy.velocity.x) < 10.0 and enemy.is_on_floor():
		enemy.sprite.modulate = Color(1, 1, 1) # Reset color just in case
		transitioned.emit(self, "idlestate")
