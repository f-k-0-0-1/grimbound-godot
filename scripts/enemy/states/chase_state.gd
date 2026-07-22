extends State
class_name ChaseState

var enemy: EnemyBase
var player: CharacterBody2D
var last_direction: float = 0.0

@export var chase_speed_multiplier: float = 1.5
@export var attack_range: float = 65.0

func enter() -> void:
	enemy = owner as EnemyBase
	last_direction = 0.0
	
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
	
	if enemy.sprite and enemy.sprite.sprite_frames.has_animation("walk"):
		enemy.sprite.play("walk")

func physics_update(_delta: float) -> void:
	if not enemy or not enemy.stats or not player:
		return

	var direction = sign(player.global_position.x - enemy.global_position.x)
	enemy.velocity.x = direction * (enemy.stats.speed * chase_speed_multiplier)
	
	# ✅ Only update hitbox if direction changed
	if direction != last_direction:
		last_direction = direction
		
		if enemy.sprite:
			enemy.sprite.flip_h = direction < 0
		
		if enemy.has_method("flip_hitbox"):
			enemy.flip_hitbox(direction)
	
	var distance_to_player = enemy.global_position.distance_to(player.global_position)
	
	if distance_to_player <= attack_range:
		transitioned.emit(self, "attackstate")
		return

	if distance_to_player > enemy.stats.aggro_range * 2.0:
		transitioned.emit(self, "patrolstate")
