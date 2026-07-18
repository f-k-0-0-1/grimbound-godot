extends Node

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
