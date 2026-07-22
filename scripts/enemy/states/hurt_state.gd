extends State
class_name HurtState

var enemy: EnemyBase
@export var knockback_friction: float = 1200.0 
@export var stun_duration: float = 0.4 

var current_stun_time: float = 0.0

func enter() -> void:
	enemy = owner as EnemyBase
	current_stun_time = stun_duration
	
	if enemy.sprite and enemy.sprite.sprite_frames.has_animation("hurt"):
		enemy.sprite.play("hurt")
	else:
		enemy.sprite.modulate = Color(1, 0, 0) # Flash Red fallback

func physics_update(delta: float) -> void:
	current_stun_time -= delta
	
	# Apply friction to halt the knockback slide
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, knockback_friction * delta)
	
	if not enemy.is_on_floor():
		enemy.velocity.x = 0
		
	# Once the stun timer has completely expired, re-engage the player aggressively!
	if current_stun_time <= 0.0 and abs(enemy.velocity.x) < 10.0 and enemy.is_on_floor():
		enemy.sprite.modulate = Color(1, 1, 1) # Reset color
		
		# Check distance to player to decide whether to chase or attack immediately
		var players = get_tree().get_nodes_in_group("Player")
		if players.size() > 0:
			var player = players[0]
			var distance = enemy.global_position.distance_to(player.global_position)
			
			if distance <= 75.0:
				transitioned.emit(self, "attackstate")
			else:
				transitioned.emit(self, "chasestate")
		else:
			transitioned.emit(self, "patrolstate")
