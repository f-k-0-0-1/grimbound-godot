extends Area2D

@export_multiline var message: String = "Default guide text."

# Preload the font to avoid first-time loading delay
const CustomFont = preload("res://fonts/EightBitDragon-anqx.ttf")  # ← Update path

@onready var label: Label = $Label

func _ready() -> void:
	# Assign the preloaded font
	label.add_theme_font_override("font", CustomFont)
	
	# Apply the text from the Inspector and hide it by default
	label.text = message
	label.hide()
	
	# Connect the Area2D signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		label.show()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		await get_tree().create_timer(3.0).timeout
		if not overlaps_body(body):
			label.hide()
