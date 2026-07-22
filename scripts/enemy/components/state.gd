extends Node
class_name State

# Tells the StateMachine to switch to a different state (e.g., from Idle to Chase)
signal transitioned(state: State, new_state_name: String)

# Called exactly once when the state becomes active
func enter() -> void:
	pass

# Called exactly once when the state finishes and swaps to another
func exit() -> void:
	pass

# Mirrors the engine's standard _process()
func update(_delta: float) -> void:
	pass

# Mirrors the engine's standard _physics_process()
func physics_update(_delta: float) -> void:
	pass
