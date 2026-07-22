extends Area2D
class_name HitBox

@export var damage: int = 10
@export var knockback_force: float = 300.0
@export var hitbox_offset: float = 40.0  # ← Distance from center to hitbox

@onready var collider: CollisionShape2D = $CollisionShape2D

var hit_targets: Array[Area2D] = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func update_facing_direction(facing_dir: float) -> void:
	if facing_dir != 0:
		# Move the hitbox to the correct side
		position.x = hitbox_offset * sign(facing_dir)
		
		# Flip the collision shape's scale (optional for asymmetric shapes)
		if collider:
			collider.scale.x = sign(facing_dir)

func _on_area_entered(area: Area2D) -> void:
	_check_and_deal_damage(area)

func _physics_process(_delta: float) -> void:
	if collider and not collider.disabled:
		for area in get_overlapping_areas():
			_check_and_deal_damage(area)
	else:
		if hit_targets.size() > 0:
			hit_targets.clear()

func _check_and_deal_damage(area: Area2D) -> void:
	if collider and collider.disabled:
		return
		
	if hit_targets.has(area):
		return

	if area is HurtBox:
		if area.owner == owner:
			return
			
		print("✅ HitBox struck ", area.owner.name, "! Dealing damage.")
		
		hit_targets.append(area)
		
		var direction_to_target = global_position.direction_to(area.global_position)
		var knockback = direction_to_target * knockback_force
		area.take_damage(damage, knockback)
