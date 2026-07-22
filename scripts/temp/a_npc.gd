extends CharacterBody2D

@onready var interaction_zone: Area2D = $InteractionZone
@onready var speech_label: Label = $Panel/Label
@onready var speech_panel: Panel = $Panel
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var dialogue_text: String = "Hiii, i am Haji mohd. Amir\ni want to sing a song for you!"
@export var song_name: String = "song_1"

var has_triggered: bool = false

func _ready() -> void:
	# Hide text on start
	speech_panel.visible = false
	speech_label.text = dialogue_text
	
	# Play NPC idle animation if available
	if animated_sprite and animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("Idle"):
		animated_sprite.play("Idle")
	
	# Connect the Area2D signal safely via code
	if interaction_zone:
		interaction_zone.body_entered.connect(_on_player_entered)

func _on_player_entered(body: Node2D) -> void:
	# Check if it's the player using the group tag established in your project
	if body.is_in_group("Player") and not has_triggered:
		has_triggered = true
		
		# 1. Show the speech panel and text immediately
		speech_panel.visible = true
		
		# 2. Play the NPC voice effect sound from AudioManager simultaneously with the text
		if AudioManager.has_method("stop_music"):
			AudioManager.stop_music()
		
		if AudioManager.has_method("play_sfx"):
			AudioManager.play_sfx("npc_voice")
		
		# 3. Wait for 2 seconds before playing the song
		await get_tree().create_timer(4.0).timeout
		
		# 4. Stop the current background music
		if AudioManager.has_method("stop_music"):
			AudioManager.stop_music()
		
		# 5. Play the NPC's song from the AudioManager (faded in slightly for polish)
		if AudioManager.has_method("play_music"):
			AudioManager.play_music(song_name, 1.0)
