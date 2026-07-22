## MenuPlayer - Player preview with swipe movement, falling, jump, and respawn
extends CharacterBody2D

@export var move_speed: float = 200.0
@export var jump_force: float = -450.0
@export var gravity: float = 1200.0
@export var friction: float = 0.85
@export var acceleration: float = 0.92
@export var swipe_threshold: float = 30.0
@export var fall_threshold: float = 1000.0        # Y position to trigger respawn
@export var spawn_position: Vector2 = Vector2.ZERO # Respawn point

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var current_direction: int = 1
var swipe_direction: float = 0.0
var is_dragging: bool = false
var touch_start: Vector2 = Vector2.ZERO
var jump_requested: bool = false
var on_floor: bool = false

signal swipe_detected(direction: String)

func _ready() -> void:
	# Set spawn position to current position if not set
	if spawn_position == Vector2.ZERO:
		spawn_position = global_position
	call_deferred("_apply_skin_deferred")

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

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		_handle_drag(event.relative, event.position)
	elif event is InputEventMouseButton and event.pressed:
		is_dragging = true
		touch_start = get_global_mouse_position()
	elif event is InputEventMouseMotion and is_dragging and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_handle_drag(event.relative, event.global_position)
	elif event is InputEventMouseButton and not event.pressed:
		is_dragging = false
		swipe_direction = 0.0

func _handle_drag(relative: Vector2, global_pos: Vector2) -> void:
	if not is_dragging:
		is_dragging = true
		touch_start = global_pos
		return
	
	var delta = global_pos - touch_start
	
	# Horizontal swipe
	if abs(delta.x) > swipe_threshold:
		var direction = "right" if delta.x > 0 else "left"
		swipe_detected.emit(direction)
		swipe_direction = sign(delta.x)
		current_direction = 1 if delta.x > 0 else -1
		sprite.flip_h = current_direction < 0
	else:
		swipe_direction = 0.0
	
	# Vertical swipe up - request jump
	if delta.y < -swipe_threshold:
		jump_requested = true

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump()
	_handle_movement()
	move_and_slide()
	_update_floor_status()
	_update_animation()
	_check_fall()

func _apply_gravity(delta: float) -> void:
	if not on_floor:
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, 1500.0)
	else:
		velocity.y = 0.0

func _handle_jump() -> void:
	if jump_requested and on_floor:
		velocity.y = jump_force
		on_floor = false
	jump_requested = false

func _handle_movement() -> void:
	if swipe_direction != 0:
		velocity.x = lerp(velocity.x, swipe_direction * move_speed, 1.0 - acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, 1.0 - friction)
		if abs(velocity.x) < 1.0:
			velocity.x = 0.0

func _update_floor_status() -> void:
	on_floor = is_on_floor()

func _update_animation() -> void:
	if not sprite or not sprite.sprite_frames:
		return
	
	var anim = "Idle"
	
	if not on_floor:
		if velocity.y < 0:
			anim = "Jump_Start"
		else:
			anim = "Falling_Down"
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
	on_floor = false
	jump_requested = false
	# Reset animation
	if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("Idle"):
		sprite.play("Idle")
