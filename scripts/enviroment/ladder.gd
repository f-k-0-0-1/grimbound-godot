extends Area2D

func _ready() -> void:
	# Connect the trigger zones
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if "active_ladders" in body:
			body.active_ladders += 1

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if "active_ladders" in body:
			body.active_ladders -= 1
