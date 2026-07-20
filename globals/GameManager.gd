extends Node

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

signal coins_updated(new_total: int)

var current_state: GameState = GameState.MENU
var selected_skin: int = -1
var total_coins: int = 0

func _ready() -> void:
	# Load Skin
	selected_skin = SaveManager.load_skin()
	if selected_skin < 0:
		selected_skin = -1
	print("Loaded skin:", selected_skin)
	
	# Load Coins
	total_coins = SaveManager.load_coins()
	print("Loaded coins:", total_coins)

# --- Skin Logic ---

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

# --- Coin Logic ---

func add_coin(amount: int = 1) -> void:
	total_coins += amount
	coins_updated.emit(total_coins)
	# Save immediately to the file so it's not lost if the game crashes
	SaveManager.save_coins(total_coins)
	print("Total Coins: ", total_coins)
	
func get_coins() -> int:
	return total_coins

func reset_coins() -> void:
	total_coins = 0
	SaveManager.save_coins(total_coins)
