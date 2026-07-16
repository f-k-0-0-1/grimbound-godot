## Player - Loads skin from GameManager
extends CharacterBody2D

@export var move_speed: float = 420.0
@export var jump_force: float = -450.0
@export var gravity: float = 1200.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	print("Player: _ready START")
	_apply_skin()
	print("Player: _ready END")

func refresh_skin() -> void:
	print("Player: refresh_skin")
	_apply_skin()

func _apply_skin() -> void:
	var skin := GameManager.get_selected_skin()

	if skin == null:
		push_warning("No player skin selected.")
		return

	sprite.sprite_frames = skin
	sprite.play("Idle")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * move_speed
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)

	move_and_slide()
	_update_animation(direction)

func _update_animation(direction: float) -> void:
	var anim = "Idle"
	
	if not is_on_floor():
		if velocity.y < 0:
			anim = "Jump_Start"
		else:
			anim = "Falling_Down"
	elif direction != 0:
		anim = "Running"
	
	if sprite.sprite_frames and sprite.sprite_frames.has_animation(anim):
		if sprite.animation != anim:
			sprite.play(anim)
