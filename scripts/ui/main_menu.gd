## MainMenu - Menu controller with skin selection (lazy loading)
extends CanvasLayer

# Button references
@onready var play_button: Button = $Buttons/VBoxContainer/PlayButton
@onready var quit_button: Button = $Buttons/VBoxContainer/QuitButton
@onready var skin_button: Button = $Buttons/VBoxContainer/SkinButton
@onready var settings_button: Button = $Buttons/VBoxContainer/SettingsButton
@onready var character_popup: Control = $character_select_popup
@onready var player: CharacterBody2D = $MenuPlayer

# Skin buttons
@onready var skin_button_1: TextureButton = $character_select_popup/BlurPanel/Panel/TextureButton
@onready var skin_button_2: TextureButton = $character_select_popup/BlurPanel/Panel2/TextureButton2
@onready var skin_button_3: TextureButton = $character_select_popup/BlurPanel/Panel3/TextureButton3

# Tutorial label – adjust path if needed
@onready var tutorial_label: Label = $TutorialOverlay

# Preload scenes
var level_01: PackedScene = preload("res://scenes/levels/level_01.tscn")
const SETTINGS_SCENE = preload("res://scenes/ui/settings.tscn")

# Skin cache
var _skin_cache: Dictionary = {}
var _tutorial_tween: Tween = null

func _ready() -> void:
	AudioManager.play_music("bg_music_1")
	# Connect buttons
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	skin_button.pressed.connect(_on_skin_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	
	skin_button_1.pressed.connect(_on_skin_1_pressed)
	skin_button_2.pressed.connect(_on_skin_2_pressed)
	skin_button_3.pressed.connect(_on_skin_3_pressed)
	
	# Connect player swipe signal
	if player and player.has_signal("swipe_detected"):
		player.swipe_detected.connect(_on_player_swipe)
	
	# Load saved skin
	_load_saved_skin()
	
	if not GameManager.has_selected_skin():
		character_popup.visible = true
	else:
		character_popup.visible = false
		_show_tutorial_label()

func _load_saved_skin() -> void:
	if GameManager.has_selected_skin():
		_apply_skin_to_preview(GameManager.get_selected_skin_index())

func _get_skin(index: int) -> SpriteFrames:
	if _skin_cache.has(index):
		return _skin_cache[index]
	
	var path = "res://resources/player_skins/Reaper_" + str(index + 1) + ".tres"
	var skin = load(path)
	if skin:
		_skin_cache[index] = skin
	return skin

func _apply_skin_to_preview(index: int) -> void:
	var skin_frames = _get_skin(index)
	if not skin_frames or not player or not player.has_method("refresh_skin"):
		return
	player.refresh_skin()

func _on_skin_pressed() -> void:
	AudioManager.play_sfx("button_click")
	character_popup.visible = true

func _on_skin_1_pressed() -> void:
	AudioManager.play_sfx("button_click")
	GameManager.set_selected_skin(0)
	_apply_skin_to_preview(0)
	character_popup.visible = false
	_show_tutorial_label()

func _on_skin_2_pressed() -> void:
	AudioManager.play_sfx("button_click")
	GameManager.set_selected_skin(1)
	_apply_skin_to_preview(1)
	character_popup.visible = false
	_show_tutorial_label()

func _on_skin_3_pressed() -> void:
	AudioManager.play_sfx("button_click")
	GameManager.set_selected_skin(2)
	_apply_skin_to_preview(2)
	character_popup.visible = false
	_show_tutorial_label()

func _show_tutorial_label() -> void:
	if not tutorial_label:
		return
	
	tutorial_label.visible = true
	tutorial_label.modulate = Color(1, 1, 1, 1)
	tutorial_label.scale = Vector2.ONE
	
	if _tutorial_tween and _tutorial_tween.is_valid():
		_tutorial_tween.kill()
	
	# Animate: pulse scale + fade
	_tutorial_tween = create_tween()
	_tutorial_tween.set_loops()
	_tutorial_tween.tween_property(tutorial_label, "scale", Vector2(1.05, 1.05), 0.8)
	_tutorial_tween.tween_property(tutorial_label, "scale", Vector2(0.95, 0.95), 0.8)
	_tutorial_tween.parallel().tween_property(tutorial_label, "modulate:a", 0.7, 0.8)
	_tutorial_tween.parallel().tween_property(tutorial_label, "modulate:a", 1.0, 0.8)

func _hide_tutorial_label() -> void:
	if not tutorial_label:
		return
	
	if _tutorial_tween and _tutorial_tween.is_valid():
		_tutorial_tween.kill()
	
	var tween = create_tween()
	tween.tween_property(tutorial_label, "modulate:a", 0.0, 0.3)
	tween.tween_callback(func(): tutorial_label.visible = false)

func _on_player_swipe(direction: String) -> void:
	if tutorial_label and tutorial_label.visible:
		_hide_tutorial_label()

func _on_play_pressed() -> void:
	AudioManager.play_sfx("button_click")
	AudioManager.stop_music(0.5)
	_animate_button(play_button)
	
	await get_tree().create_timer(0.2).timeout
	
	if SceneManager:
		SceneManager.go_to_level_01()
	else:
		get_tree().change_scene_to_packed(level_01)

func _on_settings_pressed() -> void:
	AudioManager.play_sfx("button_click")
	_animate_button(settings_button)
	
	# Option 1: If using SceneManager
	if SceneManager:
		SceneManager.go_to_settings()
	else:
		# Option 2: If instancing dynamically like pause menu
		var settings_instance = SETTINGS_SCENE.instantiate()
		if settings_instance.has_method("set_background_visible"):
			settings_instance.set_background_visible(true) # Keep background visible in main menu!
		get_tree().root.add_child(settings_instance)
		$Buttons.hide()
		
		if settings_instance.has_signal("settings_closed"):
			settings_instance.settings_closed.connect(func():
				$Buttons.show()
				settings_instance.queue_free()
			)

func _on_quit_pressed() -> void:
	AudioManager.play_sfx("button_click")
	_animate_button(quit_button)
	get_tree().quit()

func _animate_button(button: Button) -> void:
	if not button:
		return
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(button, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1)
