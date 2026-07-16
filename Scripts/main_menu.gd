## MainMenu - Menu controller with skin selection
extends CanvasLayer

# Buttons
@onready var play_button: Button = $Buttons/VBoxContainer/PlayButton
@onready var quit_button: Button = $Buttons/VBoxContainer/QuitButton
@onready var character_popup: Control = $character_select_popup

# Skin buttons
@onready var skin_button_1: TextureButton = $character_select_popup/BlurPanel/Panel/TextureButton
@onready var skin_button_2: TextureButton = $character_select_popup/BlurPanel/Panel2/TextureButton2
@onready var skin_button_3: TextureButton = $character_select_popup/BlurPanel/Panel3/TextureButton3

# Preview player
@onready var player: CharacterBody2D = $Player

# Level
@onready var level_01: PackedScene = preload("res://scenes/levels/level_01.tscn")


func _ready() -> void:
	_connect_signals()

	# Show or hide character selection
	if GameManager.has_selected_skin():
		character_popup.hide()
		play_button.disabled = false
		player.refresh_skin()
	else:
		character_popup.show()
		play_button.disabled = true


func _connect_signals() -> void:
	if !play_button.pressed.is_connected(_on_play_pressed):
		play_button.pressed.connect(_on_play_pressed)

	if !quit_button.pressed.is_connected(_on_quit_pressed):
		quit_button.pressed.connect(_on_quit_pressed)

	if !skin_button_1.pressed.is_connected(_on_skin_1_pressed):
		skin_button_1.pressed.connect(_on_skin_1_pressed)

	if !skin_button_2.pressed.is_connected(_on_skin_2_pressed):
		skin_button_2.pressed.connect(_on_skin_2_pressed)

	if !skin_button_3.pressed.is_connected(_on_skin_3_pressed):
		skin_button_3.pressed.connect(_on_skin_3_pressed)


func _select_skin(index: int) -> void:
	GameManager.set_selected_skin(index)

	player.refresh_skin()

	character_popup.hide()
	play_button.disabled = false


func _on_skin_1_pressed() -> void:
	_select_skin(0)


func _on_skin_2_pressed() -> void:
	_select_skin(1)


func _on_skin_3_pressed() -> void:
	_select_skin(2)


func _on_play_pressed() -> void:
	if !GameManager.has_selected_skin():
		return

	_animate_button(play_button)
	await get_tree().create_timer(0.15).timeout

	get_tree().change_scene_to_packed(level_01)


func _on_quit_pressed() -> void:
	_animate_button(quit_button)
	await get_tree().create_timer(0.15).timeout

	get_tree().quit()


func _animate_button(button: Button) -> void:
	var tween := create_tween()

	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		button,
		"scale",
		Vector2(0.95, 0.95),
		0.08
	)

	tween.tween_property(
		button,
		"scale",
		Vector2.ONE,
		0.08
	)
