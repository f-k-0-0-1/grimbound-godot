extends Node

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

var current_state: GameState = GameState.MENU
var selected_skin: int = -1

# Skin paths (not preloaded)
const SKIN_PATHS: Array[String] = [
	"res://resources/player_skins/Reaper_1.tres",
	"res://resources/player_skins/Reaper_2.tres",
	"res://resources/player_skins/Reaper_3.tres"
]

# Cached skins (loaded on demand)
var _skin_cache: Dictionary = {}

func _ready() -> void:
	selected_skin = SaveManager.load_skin()

	# First launch
	if selected_skin < 0 or selected_skin >= SKIN_PATHS.size():
		selected_skin = -1

	print("Loaded skin index:", selected_skin)

func has_selected_skin() -> bool:
	return selected_skin >= 0

func set_selected_skin(index: int) -> void:
	if index < 0 or index >= SKIN_PATHS.size():
		push_error("Invalid skin index: %d" % index)
		return

	selected_skin = index
	SaveManager.save_skin(index)
	print("Selected skin:", selected_skin)

func get_selected_skin() -> SpriteFrames:
	if selected_skin < 0 or selected_skin >= SKIN_PATHS.size():
		return null
	
	# Check cache first
	if _skin_cache.has(selected_skin):
		return _skin_cache[selected_skin]
	
	# Load lazily
	var path = SKIN_PATHS[selected_skin]
	var skin = load(path)
	
	if skin:
		_skin_cache[selected_skin] = skin
		print("Skin loaded: ", path)
	else:
		push_error("Failed to load skin: ", path)
	
	return skin

func get_skin_at_index(index: int) -> SpriteFrames:
	if index < 0 or index >= SKIN_PATHS.size():
		return null
	
	# Check cache first
	if _skin_cache.has(index):
		return _skin_cache[index]
	
	# Load lazily
	var path = SKIN_PATHS[index]
	var skin = load(path)
	
	if skin:
		_skin_cache[index] = skin
		print("Skin loaded: ", path)
	else:
		push_error("Failed to load skin: ", path)
	
	return skin

func preload_skin(index: int) -> void:
	if index < 0 or index >= SKIN_PATHS.size():
		return
	
	# Load in background (optional)
	if not _skin_cache.has(index):
		var path = SKIN_PATHS[index]
		var skin = load(path)
		if skin:
			_skin_cache[index] = skin

func preload_all_skins() -> void:
	for i in SKIN_PATHS.size():
		preload_skin(i)
