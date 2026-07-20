extends Control

# --- UI REFERENCES ---
@onready var music_slider: HSlider = $MusicSlider
@onready var sfx_slider: HSlider = $SfxSlider
@onready var back_button: TextureButton = $BackButton

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

func _on_music_slider_changed(value: float) -> void:
	# Multiply the value by itself (square it) before converting to decibels
	# This forces the middle of the slider to be appropriately quieter
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value * value))

func _on_sfx_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value * value))
	
func _on_back_button_pressed() -> void :
	SceneManager.go_to_menu()

func _exit_tree() -> void:
	# Grab the final positions of the sliders and save them to the hard drive
	SaveManager.save_audio_settings(music_slider.value, sfx_slider.value)
