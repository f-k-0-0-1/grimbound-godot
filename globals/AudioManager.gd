extends Node

# --- MUSIC DICTIONARY ---
var bgm_tracks = {
	"bg_music_1": preload("res://audio/bg_music/bg_music_1.ogg"),
	"song_1": preload("res://audio/bg_music/song_1.mp3"),
	"bg_music_2": preload("res://audio/bg_music/bg_music_2.ogg")
}

# --- SFX DICTIONARY ---
var sfx_tracks = {
	"button_click": preload("res://audio/sfx/button_click.ogg"),
	"npc_voice": preload("res://audio/sfx/npc_voice.mp3"),
	"coin": preload("res://audio/sfx/coin_sfx.ogg"),
	"enemy_death": preload("res://audio/sfx/enemy_death.ogg"),
	"fireball": preload("res://audio/sfx/fireball.ogg"),
	"game_over": preload("res://audio/sfx/game over.ogg"),
	"jump": preload("res://audio/sfx/jump.ogg"),
	"level_over": preload("res://audio/sfx/Level_Over.ogg"),
	"lightning": preload("res://audio/sfx/lightning_ability.ogg"),
	"pickup": preload("res://audio/sfx/pickup sound effect.ogg"),
	"player_hurt": preload("res://audio/sfx/player_hurt.ogg"),
	"star_twinkle": preload("res://audio/sfx/star_twinkle.ogg"),
	"sword_swing": preload("res://audio/sfx/sword_swing_sfx.ogg"),
	"walk": preload("res://audio/sfx/walking-on-grass.ogg"),
	"walk_1": preload("res://audio/sfx/walk_1.ogg"),
	"walk_2": preload("res://audio/sfx/walk_2.ogg"),
	"teleport": preload("res://audio/sfx/teleport_sfx.ogg")
}

var _music_tween: Tween

var music_player: AudioStreamPlayer
var sfx_pool: Array[AudioStreamPlayer] = []
@export var sfx_pool_size: int = 8

var saved_vols = SaveManager.load_audio_settings()
var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")

func _ready() -> void:

	AudioServer.set_bus_volume_db(music_bus, linear_to_db(saved_vols.music * saved_vols.music))
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(saved_vols.sfx * saved_vols.sfx))
	
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	for i in range(sfx_pool_size):
		var p = AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		sfx_pool.append(p)

func play_music(track_name: String, fade_duration: float = 0.0) -> void:
	if not bgm_tracks.has(track_name):
		push_warning("AudioManager: Music track '%s' not found." % track_name)
		return
		
	# Don't restart the track if it's already playing
	if music_player.stream == bgm_tracks[track_name] and music_player.playing:
		return
		
	# 1. Safely kill any existing fade tweens so they don't fight each other
	if _music_tween and _music_tween.is_valid():
		_music_tween.kill()
	
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# 2. Set the track and start playing
	music_player.stream = bgm_tracks[track_name]
	music_player.play()
	
	# 3. Handle the Fade
	if fade_duration > 0.0:
		# Start the volume extremely low (effectively silent)
		music_player.volume_db = -40.0 
		
		# Create a new tween to animate the volume back up to 0.0 dB (normal volume)
		_music_tween = create_tween()
		_music_tween.tween_property(music_player, "volume_db", 0.0, fade_duration)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
	else:
		# If no fade duration is passed, play at normal volume instantly
		music_player.volume_db = 0.0

func stop_music(fade_duration: float = 0.0) -> void:
	if fade_duration > 0.0:
		if _music_tween and _music_tween.is_valid():
			_music_tween.kill()
			
		_music_tween = create_tween()
		# Fade down to -40dB, then completely stop the player once the tween finishes
		_music_tween.tween_property(music_player, "volume_db", -40.0, fade_duration)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_IN)
			
		_music_tween.finished.connect(music_player.stop)
	else:
		music_player.stop()

# We add volume_db with a default of 0.0 so old code doesn't break!
func play_sfx(sfx_name: String, pitch_variance: float = 0.0, volume_db: float = 0.0) -> void:
	if not sfx_tracks.has(sfx_name):
		push_warning("AudioManager: SFX track '%s' not found." % sfx_name)
		return
		
	for player in sfx_pool:
		if not player.playing:
			player.stream = sfx_tracks[sfx_name]
			
			if pitch_variance > 0.0:
				player.pitch_scale = randf_range(1.0 - pitch_variance, 1.0 + pitch_variance)
			else:
				player.pitch_scale = 1.0
				
			# NEW: Apply the requested volume adjustment
			player.volume_db = volume_db 
			
			player.play()
			return
			
	push_warning("AudioManager: SFX Pool is full. Cannot play '%s'." % sfx_name)
