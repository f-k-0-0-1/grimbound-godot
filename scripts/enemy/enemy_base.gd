extends CharacterBody2D
class_name EnemyBase

# --- PILLAR 1: THE DATA ---
# This creates a slot in the Inspector to drop your goblin_data.tres!
@export var stats: EnemyStats

# --- SIGNALS ---
signal health_changed(new_health: int, max_health: int)
signal died

# --- INTERNAL STATE ---
var current_health: int
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# --- PILLAR 2: THE COMPONENTS ---
@onready var hurt_box: HurtBox = $HurtBox
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# 1. Validate that we actually plugged data into this enemy
	if not stats:
		push_error("EnemyBase has no EnemyStats resource assigned!")
		return
		
	# 2. Set starting health based on the Resource data
	current_health = stats.max_health
	
	# 3. Connect our HurtBox to listen for damage
	if hurt_box:
		hurt_box.took_damage.connect(_on_took_damage)

func _physics_process(delta: float) -> void:
	# Apply universal gravity so we don't have to write it in every AI state
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# We call move_and_slide here. 
	# The AI State Machine will dictate the velocity.x later.
	move_and_slide()

# This is triggered automatically when a sword (HitBox) touches the HurtBox
func _on_took_damage(amount: int, knockback: Vector2) -> void:
	current_health -= amount
	health_changed.emit(current_health, stats.max_health)
	
	# Optional: Apply knockback from the weapon
	velocity = knockback
	
	print(name + " took damage! Health: " + str(current_health))
	
	if current_health <= 0:
		die()

func die() -> void:
	died.emit()
	print(name + " has died!")
	# Loot and death animation logic will go here
	queue_free()
