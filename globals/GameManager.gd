extends Node

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

var current_state: GameState = GameState.MENU
var selected_skin: int = -1

func _ready() -> void:
	selected_skin = SaveManager.load_skin()

	# First launch
	if selected_skin < 0:
		selected_skin = -1

	print("Loaded skin:", selected_skin)

func has_selected_skin() -> bool:
	return selected_skin >= 0

func set_selected_skin(index: int) -> void:
	if index < 0:
		push_error("Invalid skin index: %d" % index)
		return

	selected_skin = index
	SaveManager.save_skin(index)
	print("Selected skin:", selected_skin)

func get_selected_skin_index() -> int:
	return selected_skin
