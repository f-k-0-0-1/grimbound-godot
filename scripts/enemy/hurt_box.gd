extends Area2D
class_name HurtBox

# Signal to tell the parent entity (the enemy or player) that it got hit
signal took_damage(amount: int, knockback_vector: Vector2)

func _ready() -> void:
	# A HurtBox shouldn't physically push other objects around
	monitorable = false

# This function is designed to be called by a HitBox that enters this area
func take_damage(damage_amount: int, knockback: Vector2 = Vector2.ZERO) -> void:
	took_damage.emit(damage_amount, knockback)
