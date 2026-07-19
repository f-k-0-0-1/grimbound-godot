## Player - Clean player controller with smooth movement and respawn
extends CharacterBody2D

@export var move_speed: float = 550.0
@export var jump_force: float = -850.0
@export var gravity: float = 1200.0
@export var friction: float = 0.85
@export var acceleration: float = 0.92
@export var fall_threshold: float = 1000.0  # Y position to trigger respawn
@export var spawn_position: Vector2 = Vector2.ZERO

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var current_direction: int = 1

func _ready() -> void:
	call_deferred("_apply_skin_deferred")
	# Set spawn position to current position if not set
	if spawn_position == Vector2.ZERO:
		spawn_position = global_position

func refresh_skin() -> void:
	if is_inside_tree():
		_apply_skin()
	else:
		call_deferred("_apply_skin_deferred")

func _apply_skin_deferred() -> void:
	if not is_inside_tree():
		return
	_apply_skin()

func _apply_skin() -> void:
	if not sprite or not GameManager.has_selected_skin():
		return
	
	var skin_index = GameManager.get_selected_skin_index()
	var path = "res://resources/player_skins/Reaper_" + str(skin_index + 1) + ".tres"
	var skin_frames = load(path)
	
	if skin_frames:
		sprite.sprite_frames = skin_frames
		if sprite.sprite_frames.has_animation("Idle"):
			sprite.play("Idle")

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump()
	_handle_movement(delta) # Pass delta here
	_update_animation()
	
	# Jitter Fix: Snap floating point micro-velocities to absolute zero before moving
	if abs(velocity.x) < 1.0:
		velocity.x = 0.0
		
	move_and_slide()
	_check_fall()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, 1500.0)

func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

func _handle_movement(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		# Frame-rate independent acceleration (maintaining your existing export scale)
		velocity.x = lerp(velocity.x, direction * move_speed, (1.0 - acceleration) * 60.0 * delta)
		current_direction = sign(direction)
		sprite.flip_h = direction < 0
	else:
		# Frame-rate independent friction
		velocity.x = lerp(velocity.x, 0.0, (1.0 - friction) * 60.0 * delta)
		
func _update_animation() -> void:
	if not sprite or not sprite.sprite_frames:
		return
	
	var anim = "Idle"
	
	if not is_on_floor():
		anim = "Jump_Start" if velocity.y < 0 else "Falling_Down"
	elif abs(velocity.x) > 10:
		anim = "Running"
	
	if sprite.sprite_frames.has_animation(anim) and sprite.animation != anim:
		sprite.play(anim)

func _check_fall() -> void:
	if global_position.y > fall_threshold:
		respawn()

func respawn() -> void:
	# Reset position and velocity
	global_position = spawn_position
	velocity = Vector2.ZERO
	# Optionally reset health or other state
	# Play respawn animation if available
	if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("Idle"):
		sprite.play("Idle")
