## MainMenu - Menu controller with skin selection (lazy loading)
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

# Skin cache (loaded on demand)
var _skin_cache: Dictionary = {}

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
		_apply_skin_to_preview(GameManager.get_selected_skin_index())

func _get_skin(index: int) -> SpriteFrames:
	# Check cache first
	if _skin_cache.has(index):
		return _skin_cache[index]
	
	# Load on demand
	var path = "res://resources/player_skins/Reaper_" + str(index + 1) + ".tres"
	print("MainMenu: Loading skin from:", path)
	
	var skin = load(path)
	if skin:
		_skin_cache[index] = skin
		print("MainMenu: Skin loaded and cached")
	else:
		print("MainMenu: Failed to load skin")
	
	return skin

func _apply_skin_to_preview(index: int) -> void:
	var skin_frames = _get_skin(index)
	
	if not skin_frames:
		print("MainMenu: Preview update failed - no skin frames")
		return
	
	# Safety: ensure player and sprite exist
	if not player:
		print("MainMenu: Player node is null!")
		return
	
	if not player.has_method("refresh_skin"):
		print("MainMenu: Player has no refresh_skin method!")
		return
	
	# Use Player's refresh_skin method instead of direct access
	player.refresh_skin()
	print("MainMenu: Preview updated via player.refresh_skin()")

func _on_skin_1_pressed() -> void:
	GameManager.set_selected_skin(0)
	_apply_skin_to_preview(0)
	character_popup.visible = false

func _on_skin_2_pressed() -> void:
	GameManager.set_selected_skin(1)
	_apply_skin_to_preview(1)
	character_popup.visible = false

func _on_skin_3_pressed() -> void:
	GameManager.set_selected_skin(2)
	_apply_skin_to_preview(2)
	character_popup.visible = false

func _on_play_pressed() -> void:
	_animate_button(play_button)
	# Use SceneManager instead of direct change
	if SceneManager:
		SceneManager.go_to_level_01()
	else:
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
