extends State
class_name AttackState

var enemy: EnemyBase
var hit_box_collider: CollisionShape2D
var attack_timer: float = 0.0

func enter() -> void:
	enemy = owner as EnemyBase
	enemy.velocity.x = 0.0 # Plant feet firmly
	
	# Find the hit box collider safely
	if enemy.has_node("HitBox/CollisionShape2D"):
		hit_box_collider = enemy.get_node("HitBox/CollisionShape2D")
		hit_box_collider.disabled = true
		
	# VERIFY: Change "attack" to "slashing" if that is your exact animation name in the editor!
	var anim_name = "slashing"
	if enemy.sprite and enemy.sprite.sprite_frames.has_animation(anim_name):
		enemy.sprite.play(anim_name)
		enemy.sprite.frame = 0
		attack_timer = 0.8 # Standard duration for a swing
		print("🔥 AttackState ENTERED: Playing animation '", anim_name, "'")
	else:
		push_warning("AttackState: Animation not found!")
		transitioned.emit(self, "ChaseState")

func physics_update(delta: float) -> void:
	if not enemy or not enemy.sprite:
		return
		
	attack_timer -= delta
	
	# Toggle HitBox collider during active frames
	var current_frame = enemy.sprite.frame
	if current_frame >= 3 and current_frame <= 10: # Active strike window
		if hit_box_collider:
			hit_box_collider.disabled = false
	else:
		if hit_box_collider:
			hit_box_collider.disabled = true

	# Exit condition: When animation ends or timer expires, go back to chasing
	if attack_timer <= 0.0 or not enemy.sprite.is_playing():
		if hit_box_collider:
			hit_box_collider.disabled = true
		print("🏃 Attack finished. Returning to ChaseState.")
		transitioned.emit(self, "ChaseState")
