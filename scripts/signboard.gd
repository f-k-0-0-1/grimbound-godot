extends Area2D

@export_multiline var message: String = "Default guide text."

@onready var label: Label = $Label

func _ready() -> void:
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
		# Pause this specific function for 3 seconds without freezing the game
		await get_tree().create_timer(3.0).timeout
		
		# Only hide the text if the player did not walk back into the zone
		if not overlaps_body(body):
			label.hide()
