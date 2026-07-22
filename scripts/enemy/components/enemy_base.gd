extends CharacterBody2D
class_name EnemyBase

# --- PILLAR 1: THE DATA ---
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
@onready var state_machine: StateMachine = $StateMachine
@onready var aggro_area: Area2D = $AggroArea
@onready var hitbox: HitBox = $HitBox

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
	
	if aggro_area:
		aggro_area.body_entered.connect(_on_aggro_entered)

func flip_hitbox(direction: float) -> void:
	if hitbox and hitbox.has_method("update_facing_direction"):
		hitbox.update_facing_direction(direction)

func _on_aggro_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and state_machine and state_machine.current_state:
		var current_state_name = state_machine.current_state.name.to_lower()
		
		# ONLY chase if we are currently just pacing around (Patrol or Idle). 
		# This prevents interrupting an active attack or stun loop!
		if current_state_name in ["patrolstate", "idlestate"]:
			state_machine.on_child_transitioned(state_machine.current_state, "ChaseState")

func _physics_process(delta: float) -> void:
	# Apply universal gravity so we don't have to write it in every AI state
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# The AI State Machine dictates velocity.x, we handle the physical movement here.
	move_and_slide()

# This is triggered automatically when a sword (HitBox) touches the HurtBox
func _on_took_damage(amount: int, knockback: Vector2) -> void:
	current_health -= amount
	health_changed.emit(current_health, stats.max_health)
	
	print(name + " took " + str(amount) + " damage! Health: " + str(current_health))
	
	if current_health <= 0:
		if state_machine:
			state_machine.on_child_transitioned(state_machine.current_state, "DeathState")
		return
		
	# Apply flat horizontal knockback
	velocity.x = knockback.x
	
	# Instantly interrupt whatever the goblin was doing to play the hit reaction
	if state_machine and state_machine.current_state:
		state_machine.on_child_transitioned(state_machine.current_state, "HurtState")

func die() -> void:
	died.emit()
	print(name + " has died!")
	queue_free()
