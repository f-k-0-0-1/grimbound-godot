extends Node

const SETTINGS_FILE_PATH: String = "user://settings.cfg"
var config_file = ConfigFile.new()

const SAVE_PATH := "user://save.data"

# Save skin index
func save_skin(index: int) -> void:
	var data: Dictionary = _load_data()
	data["selected_skin"] = index
	_save_data(data)

# Load skin index (returns -1 if not found)
func load_skin() -> int:
	var data: Dictionary = _load_data()
	return data.get("selected_skin", -1)

# Save that tutorial has been shown (sets flag to true)
func save_tutorial_shown() -> void:
	var data: Dictionary = _load_data()
	data["tutorial_shown"] = true
	_save_data(data)

# Check if tutorial has already been shown
func is_tutorial_shown() -> bool:
	var data: Dictionary = _load_data()
	return data.get("tutorial_shown", false)

# ===== Internal helper functions =====

func _load_data() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}
	
	var content := file.get_as_text()
	var data = JSON.parse_string(content)
	return data if data != null else {}

func _save_data(data: Dictionary) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not save data.")
		return
	file.store_string(JSON.stringify(data))
	
# Save total coins
func save_coins(amount: int) -> void:
	var data: Dictionary = _load_data()
	data["total_coins"] = amount
	_save_data(data)

# Load total coins (returns 0 if not found)
func load_coins() -> int:
	var data: Dictionary = _load_data()
	return data.get("total_coins", 0)

func save_audio_settings(music_val: float, sfx_val: float) -> void:
	# Store the linear 0.0 - 1.0 values under the section "Audio"
	config_file.set_value("Audio", "music_volume", music_val)
	config_file.set_value("Audio", "sfx_volume", sfx_val)
	
	# Write it to the player's hard drive
	config_file.save(SETTINGS_FILE_PATH)

func load_audio_settings() -> Dictionary:
	# If the file exists and loads successfully
	if config_file.load(SETTINGS_FILE_PATH) == OK:
		return {
			# Get the saved value, but default to 1.0 (100%) if it doesn't exist yet
			"music": config_file.get_value("Audio", "music_volume", 1.0),
			"sfx": config_file.get_value("Audio", "sfx_volume", 1.0)
		}
	
	# If no file exists (first time playing), return 100% volume
	return {"music": 1.0, "sfx": 1.0}
