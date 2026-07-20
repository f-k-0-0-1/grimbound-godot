## Player - Clean player controller with smooth movement, respawn, and alternating footsteps
extends CharacterBody2D

@export var move_speed: float = 550.0
@export var jump_force: float = -1000.0
@export var gravity: float = 2500.0
@export var friction: float = 0.85
@export var acceleration: float = 0.92
@export var fall_threshold: float = 1000.0  # Y position to trigger respawn
@export var spawn_position: Vector2 = Vector2.ZERO

# --- Ladder Variables ---
@export var climb_speed: float = 300.0
var active_ladders: int = 0 
var ladder_cooldown: float = 0.0 

# --- Double Jump Variables ---
@export var max_jumps: int = 2
var current_jumps: int = 0

# --- Footstep Variables ---
var footstep_timer: float = 0.0
@export var footstep_interval: float = 0.35 # Time in seconds between steps
var footstep_toggle: bool = false # Flips back and forth to alternate sounds

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var current_direction: int = 1

func _ready() -> void:
	call_deferred("_apply_skin_deferred")
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
	if ladder_cooldown > 0:
		ladder_cooldown -= delta
		
	if active_ladders > 0 and ladder_cooldown <= 0.0: 
		_handle_climbing()
	else:
		if is_on_floor():
			current_jumps = 0
		elif current_jumps == 0:
			current_jumps = 1
			
		_apply_gravity(delta)
		_handle_jump()
		_handle_movement(delta)
		
	_update_animation()
	
	if abs(velocity.x) < 1.0:
		velocity.x = 0.0
		
	move_and_slide()
	_check_fall()

func _handle_climbing() -> void:
	var direction_y := Input.get_axis("move_up", "move_down")
	velocity.y = direction_y * climb_speed
	
	var direction_x := Input.get_axis("move_left", "move_right")
	velocity.x = direction_x * move_speed
	
	if Input.is_action_just_pressed("jump"):
		ladder_cooldown = 0.2 
		velocity.y = jump_force

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, 1500.0)

func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump"):
		if current_jumps < max_jumps:
			velocity.y = jump_force
			current_jumps += 1
			AudioManager.play_sfx("jump")
			
			if current_jumps > 1 and sprite and sprite.sprite_frames:
				if sprite.sprite_frames.has_animation("Jump_Start"):
					sprite.stop()
					sprite.play("Jump_Start")

func _handle_movement(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * move_speed, (1.0 - acceleration) * 60.0 * delta)
		current_direction = sign(direction)
		sprite.flip_h = direction < 0
		
		# --- Alternating Footstep Logic ---
		if is_on_floor():
			footstep_timer -= delta
			if footstep_timer <= 0.0:
				if footstep_toggle:
					AudioManager.play_sfx("walk_1", 0.1)
				else:
					AudioManager.play_sfx("walk_2", 0.1)
					
				footstep_toggle = !footstep_toggle # Flip for the next step
				footstep_timer = footstep_interval
	else:
		velocity.x = lerp(velocity.x, 0.0, (1.0 - friction) * 60.0 * delta)
		footstep_timer = 0.0
		
func _update_animation() -> void:
	if not sprite or not sprite.sprite_frames:
		return
	
	var anim = "Idle"
	
	if active_ladders > 0:
		anim = "Idle" 
	elif not is_on_floor():
		anim = "Jump_Start" if velocity.y < 0 else "Falling_Down"
	elif abs(velocity.x) > 10:
		anim = "Running"
	
	if sprite.sprite_frames.has_animation(anim) and sprite.animation != anim:
		sprite.play(anim)

func _check_fall() -> void:
	if global_position.y > fall_threshold:
		respawn()

func respawn() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("Idle"):
		sprite.play("Idle")
