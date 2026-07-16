extends Node

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

var current_state: GameState = GameState.MENU
var selected_skin: int = -1

# Centralized player skins
const PLAYER_SKINS: Array[SpriteFrames] = [
	preload("res://resources/player_skins/Reaper_1.tres"),
	preload("res://resources/player_skins/Reaper_2.tres"),
	preload("res://resources/player_skins/Reaper_3.tres")
]


func _ready() -> void:
	selected_skin = SaveManager.load_skin()

	# First launch
	if selected_skin < 0 or selected_skin >= PLAYER_SKINS.size():
		selected_skin = -1

	print("Loaded skin:", selected_skin)


func has_selected_skin() -> bool:
	return selected_skin >= 0


func set_selected_skin(index: int) -> void:
	if index < 0 or index >= PLAYER_SKINS.size():
		push_error("Invalid skin index: %d" % index)
		return

	selected_skin = index
	SaveManager.save_skin(index)

	print("Selected skin:", selected_skin)


func get_selected_skin() -> SpriteFrames:
	if selected_skin < 0 or selected_skin >= PLAYER_SKINS.size():
		return null

	return PLAYER_SKINS[selected_skin]
