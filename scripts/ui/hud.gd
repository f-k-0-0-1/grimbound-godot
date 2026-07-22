extends CanvasLayer

@onready var coin_label: Label = $Control/MarginContainer/HBoxContainer/Label
@onready var back_button: TextureButton = $Control/MarginContainer2/BackButton
@onready var player_health_bar: TextureProgressBar = $Control/MarginContainer3/PlayerHealthBar


func _ready() -> void:
	# 1. Update the UI immediately when the level loads to show saved coins and health
	_update_coin_display(GameManager.total_coins)
	_update_health_display(GameManager.current_health, GameManager.max_health)
	
	back_button.pressed.connect(_on_back_pressed)

	# 2. Tell the HUD to listen to the GameManager's signals
	GameManager.coins_updated.connect(_on_coins_updated)
	GameManager.player_health_updated.connect(_on_player_health_updated)

# --- COIN SYSTEM ---
func _on_coins_updated(new_total: int) -> void:
	_update_coin_display(new_total)

func _update_coin_display(amount: int) -> void:
	coin_label.text = str(amount)


# --- HEALTH SYSTEM ---
func _on_player_health_updated(current: float, maximum: float) -> void:
	_update_health_display(current, maximum)

func _update_health_display(current: float, maximum: float) -> void:
	player_health_bar.max_value = maximum
	player_health_bar.value = current


# --- BACK BUTTON ---
func _on_back_pressed() -> void:
	AudioManager.play_sfx("button_click")
	# Go back to main menu
	if SceneManager and SceneManager.has_method("go_to_menu"):
		SceneManager.go_to_menu()
	else:
		# Fallback: direct load
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
