extends CharacterBody2D

@export var move_speed: float = 420.0
@export var jump_force: float = -450.0
@export var gravity: float = 1200.0
@export var max_fall_speed: float = 900.0

# Sprite reference
@onready var sprite: Sprite2D = $Sprite2D  # Adjust node name if different

func _physics_process(delta: float) -> void:
	# Gravity
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0:
		velocity.x = direction * move_speed
		# Flip sprite based on direction
		_flip_sprite(direction)
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)

	move_and_slide()

# Flip sprite function
func _flip_sprite(direction: float) -> void:
	if direction < 0:
		sprite.flip_h = true   # Face left
	elif direction > 0:
		sprite.flip_h = false  # Face right
