extends Control

# References to the buttons based on your node structure
@onready var resume_button: TextureButton = $VBoxContainer/ResumeButton
@onready var restart_button: TextureButton = $VBoxContainer/RestartButton
@onready var settings_button: TextureButton = $VBoxContainer/SettingsButton
@onready var quit_button: TextureButton = $VBoxContainer/QuitButton
@onready var settings: Control = $Settings


func _ready() -> void:
	# Ensure process mode runs even when the game tree is paused
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	settings.visible = false
	
	# Connect button signals via code
	resume_button.pressed.connect(_on_resume_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()

func _toggle_pause() -> void:
	var is_paused = get_tree().paused
	get_tree().paused = not is_paused
	
	if get_tree().paused:
		show()
		resume_button.grab_focus() 
		# (Music left untouched so level track continues playing seamlessly)
	else:
		hide()

# --- Button Signal Handlers ---

func _on_resume_button_pressed() -> void:
	AudioManager.play_sfx("button_click")
	_toggle_pause()

func _on_settings_button_pressed() -> void:
	AudioManager.play_sfx("button_click")
	settings.visible = true
	$VBoxContainer.visible = true

func _on_settings_closed() -> void:
	settings.visible = false
	$VBoxContainer.visible = true
	resume_button.grab_focus()

func _on_restart_button_pressed() -> void:
	AudioManager.play_sfx("button_click")
	get_tree().paused = false 
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	AudioManager.play_sfx("button_click")
	get_tree().paused = false
	SceneManager.go_to_menu()
