extends Control

# --- UI REFERENCES ---
@onready var music_slider: HSlider = $GameAudio/MusicSlider
@onready var sfx_slider: HSlider = $GameAudio/SfxSlider
@onready var back_button: TextureButton = $BackButton

# --- NEW: CONTROL CHECK BUTTON REFERENCES ---
# Adjust these node paths if your CheckButtons are nested under containers
@onready var joystick_button: CheckButton = $GameControls/VBoxContainer/HBoxContainer2/JoystickControls
@onready var button_control: CheckButton = $GameControls/VBoxContainer/HBoxContainer/ButtonControls

#---- Left panel buttons
@onready var audio_button: Button = $Left_Bar_Buttons/AudioButton
@onready var graphics_button: Button = $Left_Bar_Buttons/GraphicsButton
@onready var controls_button: Button = $Left_Bar_Buttons/ControlsButton
@onready var credits_button: Button = $Left_Bar_Buttons/CreditsButton

@onready var game_controls: Control = $GameControls
@onready var game_graphics: Control = $GameGraphics
@onready var game_credits: Control = $GameCredits
@onready var game_audio: Control = $GameAudio


# --- BUS INDICES ---
var music_bus_index: int
var sfx_bus_index: int

func _ready() -> void:
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	
	# Load the volume, convert to linear, and apply the square root 
	# so the UI slider perfectly matches the exponential curve
	music_slider.value = sqrt(db_to_linear(AudioServer.get_bus_volume_db(music_bus_index)))
	sfx_slider.value = sqrt(db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index)))
	
	music_slider.value_changed.connect(_on_music_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	back_button.pressed.connect(_on_back_button_pressed)
	
	# Left Panel Buttons
	audio_button.pressed.connect(_on_game_audio_button_pressed)
	graphics_button.pressed.connect(_on_game_graphics_button_pressed)
	controls_button.pressed.connect(_on_game_controls_button_pressed)
	credits_button.pressed.connect(_on_game_credits_button_pressed)

	# --- NEW: LOAD AND CONNECT CONTROL SCHEME PREFERENCES ---
	var current_scheme = SaveManager.load_control_scheme() # Defaults to "joystick"
	if current_scheme == "joystick":
		joystick_button.button_pressed = true
		button_control.button_pressed = false
	else:
		joystick_button.button_pressed = false
		button_control.button_pressed = true

	joystick_button.toggled.connect(_on_joystick_control_toggled)
	button_control.toggled.connect(_on_button_control_toggled)
	
	game_controls.visible = false
	game_graphics.visible = false
	game_credits.visible = false
	game_audio.visible = true

func _on_music_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value * value))

func _on_sfx_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value * value))
	
func _on_back_button_pressed() -> void:
	AudioManager.play_sfx("button_click")
	SceneManager.go_to_menu()

# --- LEFT PANEL BUTTONS
func _on_game_audio_button_pressed() -> void:
	game_controls.visible = false
	game_graphics.visible = false
	game_credits.visible = false
	game_audio.visible = true
	
func _on_game_controls_button_pressed() -> void:
	game_controls.visible = true
	game_graphics.visible = false
	game_credits.visible = false
	game_audio.visible = false
	
func _on_game_graphics_button_pressed() -> void:
	game_controls.visible = false
	game_graphics.visible = true
	game_credits.visible = false
	game_audio.visible = false
	
func _on_game_credits_button_pressed() -> void:
	game_controls.visible = false
	game_graphics.visible = false
	game_credits.visible = true
	game_audio.visible = false

# --- NEW: CONTROL TOGGLE HANDLERS (Mutually Exclusive) ---
func _on_joystick_control_toggled(toggled_on: bool) -> void:
	AudioManager.play_sfx("button_click")
	if toggled_on:
		button_control.button_pressed = false # Uncheck buttons if joystick is selected

func _on_button_control_toggled(toggled_on: bool) -> void:
	AudioManager.play_sfx("button_click")
	if toggled_on:
		joystick_button.button_pressed = false # Uncheck joystick if buttons are selected

func _exit_tree() -> void:
	# 1. Save audio settings
	SaveManager.save_audio_settings(music_slider.value, sfx_slider.value)
	
	# 2. Save active control scheme
	var chosen_scheme = "joystick" if joystick_button.button_pressed else "buttons"
	SaveManager.save_control_scheme(chosen_scheme)
