## MainMenu - Menu controller with skin selection
extends CanvasLayer

# Button references
@onready var play_button: Button = $Buttons/VBoxContainer/PlayButton
@onready var quit_button: Button = $Buttons/VBoxContainer/QuitButton
@onready var character_popup: Control = $character_select_popup
@onready var player: CharacterBody2D = $Player

# Skin buttons
@onready var skin_button_1: TextureButton = $character_select_popup/BlurPanel/Panel/TextureButton
@onready var skin_button_2: TextureButton = $character_select_popup/BlurPanel/Panel2/TextureButton2
@onready var skin_button_3: TextureButton = $character_select_popup/BlurPanel/Panel3/TextureButton3

# Preload level
var level_01: PackedScene = preload("res://scenes/levels/level_01.tscn")

func _ready() -> void:
	print("MainMenu: _ready START")
	
	# Connect button signals
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# Connect skin buttons
	skin_button_1.pressed.connect(_on_skin_1_pressed)
	skin_button_2.pressed.connect(_on_skin_2_pressed)
	skin_button_3.pressed.connect(_on_skin_3_pressed)
	
	# Load saved skin
	_load_saved_skin()
	
	# Show popup if no skin selected
	if not GameManager.has_selected_skin():
		character_popup.visible = true
		print("MainMenu: popup shown")
	else:
		character_popup.visible = false
		print("MainMenu: popup hidden")
	
	print("MainMenu: _ready END")

func _load_saved_skin() -> void:
	if GameManager.has_selected_skin():
		player.refresh_skin()

func _on_skin_1_pressed() -> void:
	GameManager.set_selected_skin(0)
	player.refresh_skin()
	character_popup.visible = false

func _on_skin_2_pressed() -> void:
	GameManager.set_selected_skin(1)
	player.refresh_skin()
	character_popup.visible = false

func _on_skin_3_pressed() -> void:
	GameManager.set_selected_skin(2)
	player.refresh_skin()
	character_popup.visible = false

func _on_play_pressed() -> void:
	_animate_button(play_button)
	get_tree().change_scene_to_packed(level_01)

func _on_quit_pressed() -> void:
	_animate_button(quit_button)
	get_tree().quit()

func _animate_button(button: Button) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(button, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1)
