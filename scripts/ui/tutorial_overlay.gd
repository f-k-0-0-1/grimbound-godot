## TutorialOverlay - Animated swipe tutorial with arrows
extends CanvasLayer

# References based on your node structure
@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/TitleLabel
@onready var left_arrow: Label = $Panel/LeftArrow
@onready var right_arrow: Label = $Panel/RightArrow
@onready var up_arrow: Label = $Panel/UpArrow
@onready var got_it_button: Button = $Panel/GotItButton

# Store tween references for cleanup
var _tweens: Array = []

signal tutorial_complete()

func _ready() -> void:
	# Start hidden
	visible = true
	
	# Connect button
	got_it_button.pressed.connect(_on_got_it_pressed)

func show_tutorial() -> void:
	visible = true
	_start_arrow_animations()

func hide_tutorial() -> void:
	visible = false
	_stop_arrow_animations()
	tutorial_complete.emit()

func _start_arrow_animations() -> void:
	# Clear old tweens
	_stop_arrow_animations()
	
	# Animate Left Arrow (slides left and right)
	_animate_arrow(left_arrow, Vector2(-25, 0), Vector2(25, 0), 0.6)
	
	# Animate Right Arrow (slides right and left)
	_animate_arrow(right_arrow, Vector2(25, 0), Vector2(-25, 0), 0.6)
	
	# Animate Up Arrow (slides up and down)
	_animate_arrow(up_arrow, Vector2(0, -25), Vector2(0, 25), 0.6)

func _animate_arrow(arrow: Label, offset1: Vector2, offset2: Vector2, duration: float) -> void:
	# Reset position
	arrow.position = Vector2.ZERO
	
	# Create looping tween
	var tween := create_tween()
	tween.set_loops()
	tween.tween_property(arrow, "position", offset1, duration)
	tween.tween_property(arrow, "position", offset2, duration)
	
	# Store reference for cleanup
	_tweens.append(tween)

func _stop_arrow_animations() -> void:
	# Kill all stored tweens
	for tween in _tweens:
		if tween.is_valid():
			tween.kill()
	_tweens.clear()

func _on_got_it_pressed() -> void:
	hide_tutorial()
