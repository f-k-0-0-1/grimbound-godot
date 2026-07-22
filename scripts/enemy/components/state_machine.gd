extends Node
class_name StateMachine

# We will drag our starting state (like Idle or Patrol) into this box in the Inspector
@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	# Loop through all child nodes to find our specific states
	for child in get_children():
		if child is State:
			# Store states in a dictionary using their node name (in lowercase) as the key
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transitioned)
			
	if initial_state:
		initial_state.enter()
		current_state = initial_state

# Route the engine's process ticks into whatever state is currently active
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

# Handle the signal when a state wants to swap (e.g., Patrol sees player -> Chase)
func on_child_transitioned(state: State, new_state_name: String) -> void:
	# Ignore transitions from states that are not currently active
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		push_warning("State Machine: Tried to transition to a non-existent state - " + new_state_name)
		return
		
	# Clean up the old state and start the new one
	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state
