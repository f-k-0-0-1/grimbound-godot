extends CanvasLayer

@onready var coin_label: Label = $Control/MarginContainer/HBoxContainer/Label
@onready var player_health_bar: TextureProgressBar = $Control/MarginContainer3/PlayerHealthBar
@onready var pause_button: TextureButton = $Control/MarginContainer2/PauseButton
@onready var pause_menu: Control = $PauseMenu

func _ready() -> void:
	# Ensure the pause menu starts hidden
	pause_menu.visible = false
	
	# 1. Update the UI immediately when the level loads to show saved coins and health
	_update_coin_display(GameManager.total_coins)
	_update_health_display(GameManager.current_health, GameManager.max_health)
	
	pause_button.pressed.connect(_on_pause_pressed)

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


# --- PAUSE BUTTON ---
func _on_pause_pressed() -> void:
	AudioManager.play_sfx("button_click")
	
	# Toggle the game tree pause state
	var is_paused = not get_tree().paused
	get_tree().paused = is_paused
	
	# Show or hide the pause menu based on the new pause state
	pause_menu.visible = is_paused
	
	# Optional: Grab focus on the resume button so keyboard/controllers work immediately
	if is_paused:
		var resume_btn = pause_menu.get_node_or_null("MarginContainer/VBoxContainer/ResumeButton")
		if resume_btn:
			resume_btn.grab_focus()
