extends Node

const SAVE_PATH := "user://save.data"


func save_skin(index: int) -> void:
	var data = {
		"selected_skin": index
	}

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	if file == null:
		push_error("Couldn't save skin.")
		return

	file.store_string(JSON.stringify(data))


func load_skin() -> int:
	if !FileAccess.file_exists(SAVE_PATH):
		return -1

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)

	if file == null:
		return -1

	var data = JSON.parse_string(file.get_as_text())

	if data == null:
		return -1

	return data.get("selected_skin", -1)
