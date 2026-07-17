## Player - Loads skin directly using GameManager index
extends CharacterBody2D

@export var move_speed: float = 420.0
@export var jump_force: float = -450.0
@export var gravity: float = 1200.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	print("Player: _ready START")
	# Defer skin application to ensure all nodes are ready
	call_deferred("_apply_skin_deferred")
	print("Player: _ready END")

func refresh_skin() -> void:
	print("Player: refresh_skin")
	if is_inside_tree():
		_apply_skin()
	else:
		print("Player: refresh_skin - not in tree, deferring")
		call_deferred("_apply_skin_deferred")

func _apply_skin_deferred() -> void:
	if not is_inside_tree():
		print("Player: _apply_skin_deferred - not in tree, aborting")
		return
	_apply_skin()

func _apply_skin() -> void:
	print("Player: _apply_skin START")
	
	# Safety: ensure sprite exists and is ready
	if not sprite:
		print("Player: sprite is null!")
		return
	
	if not is_inside_tree():
		print("Player: not in tree, deferring")
		call_deferred("_apply_skin_deferred")
		return
	
	if not GameManager.has_selected_skin():
		print("Player: No skin selected, using default")
		return
	
	var skin_index = GameManager.get_selected_skin_index()
	print("Player: Applying skin index:", skin_index)
	
	var path = "res://resources/player_skins/Reaper_" + str(skin_index + 1) + ".tres"
	print("Player: Loading from:", path)
	
	var skin_frames = load(path)
	
	if skin_frames:
		sprite.sprite_frames = skin_frames
		print("Player: Skin frames loaded")
		# Play animation only if node is ready
		if sprite.sprite_frames and sprite.sprite_frames.has_animation("Idle"):
			sprite.play("Idle")
			print("Player: Skin applied and Idle animation started")
		else:
			print("Player: Warning - Idle animation not found")
	else:
		print("Player: Failed to load skin from:", path)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * move_speed
		if sprite:
			sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)

	move_and_slide()
	_update_animation(direction)

func _update_animation(direction: float) -> void:
	if not sprite or not sprite.sprite_frames:
		return
	
	var anim = "Idle"
	
	if not is_on_floor():
		if velocity.y < 0:
			anim = "Jump_Start"
		else:
			anim = "Falling_Down"
	elif direction != 0:
		anim = "Running"
	
	if sprite.sprite_frames.has_animation(anim):
		if sprite.animation != anim:
			sprite.play(anim)
