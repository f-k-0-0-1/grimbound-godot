extends CanvasLayer

@onready var coin_label: Label = $Control/MarginContainer/HBoxContainer/Label
@onready var back_button: TextureButton = $Control/MarginContainer2/BackButton

func _ready() -> void:
	# 1. Update the UI immediately when the level loads to show saved coins
	_update_coin_display(GameManager.total_coins)
	
	back_button.pressed.connect(_on_back_pressed)

	# 2. Tell the HUD to listen to the GameManager's signal
	GameManager.coins_updated.connect(_on_coins_updated)

# 3. This function fires automatically whenever a coin is collected
func _on_coins_updated(new_total: int) -> void:
	# Optional: Add a little UI bounce animation here using a Tween later!
	_update_coin_display(new_total)

func _update_coin_display(amount: int) -> void:
	coin_label.text = str(amount)

# Back Button
func _on_back_pressed() -> void:
	AudioManager.play_sfx("button_click")
	# Go back to main menu
	if SceneManager and SceneManager.has_method("go_to_menu"):
		SceneManager.go_to_menu()
	else:
		# Fallback: direct load
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
