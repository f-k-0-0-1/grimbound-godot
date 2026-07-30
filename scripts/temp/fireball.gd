extends Area2D

@export var speed: float = 1500.0
@export var lifetime: float = 1.0  # seconds before disappearing
@export var damage: int = 35
@export var knockback_strength: float = 400.0

var direction: Vector2 = Vector2.RIGHT

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer  

func _ready() -> void:
	sprite.flip_h = direction.x < 0
	sprite.play("fly")
	AudioManager.play_sfx("fireball")
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.start()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("_on_took_damage"):
			# Calculate directional knockback vector based on flight direction
			var knockback_force = Vector2(direction.x * knockback_strength, -100.0) # Optional slight upward pop
			body._on_took_damage(damage, knockback_force)
		
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
