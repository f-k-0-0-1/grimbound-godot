extends Area2D
class_name HitBox

@export var damage: int = 10
@export var knockback_force: float = 300.0

@onready var collider: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	# GUARD CLAUSE: If the collider is disabled, do nothing! 
	# This stops passive spawns or resting hitboxes from dealing ghost damage.
	if collider and collider.disabled:
		return

	if area.has_method("take_damage"):
		var direction_to_target = global_position.direction_to(area.global_position)
		var knockback = direction_to_target * knockback_force
		area.take_damage(damage, knockback)
