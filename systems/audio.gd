extends Node

@onready var _music_player = AudioStreamPlayer.new()

const MAX_SFX_PLAYERS = 8

var _sfx_players: Array[AudioStreamPlayer] = []
var _sound_effects = {
	"ingredient": [],
	"finish": [],
	"retry": [],
	"gold": [],
	"round_end_good": [],
	"round_end_bad": []
}
var _bgm_tracks = {}
var _current_bgm = ""
var _is_muted = false


func _ready() -> void:
	add_child(_music_player)
	_music_player.bus = "Music"
	
	for i in MAX_SFX_PLAYERS:
		var player = AudioStreamPlayer.new()
		player.bus = "Sfx"
		add_child(player)
		_sfx_players.append(player)
	
	_load_audio_assets()


func _load_audio_assets() -> void:
	_sound_effects["ingredient"] = [
		preload("res://assets/audio/ingredient.wav")
	]
	
	_sound_effects["finish"] = [
		preload("res://assets/audio/finish.wav")
	]
	
	_sound_effects["retry"] = [
		preload("res://assets/audio/retry.wav")
	]
	
	_sound_effects["gold"] = [
		preload("res://assets/audio/gold.wav")
	]
	
	_sound_effects["round_end_good"] = [
		preload("res://assets/audio/round_end_good.wav")
	]
	
	_sound_effects["round_end_bad"] = [
		preload("res://assets/audio/round_end_bad.wav")
	]
	
	_bgm_tracks["gameplay"] = preload("res://assets/audio/bgm.wav")


func is_muted() -> bool:
	return _is_muted


func mute() -> void:
	_is_muted = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), _is_muted)


func unmute() -> void:
	_is_muted = false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), _is_muted)


func _play_sfx(effect_name: String, volume_db: float = 0.0, pitch_variation: float = 0.2) -> void:
	if not _sound_effects.has(effect_name):
		return
	
	var variants = _sound_effects[effect_name]
	if variants.is_empty():
		return
	
	var sound = variants.pick_random()
	var player = _get_available_sfx_player()
	if player:
		player.stream = sound
		player.volume_db = volume_db
		
		var pitch_range = pitch_variation
		player.pitch_scale = randf_range(1.0 - pitch_range, 1.0 + pitch_range)
		
		player.play()


func play_sfx_ingredient() -> void:
	_play_sfx("ingredient", 0.0, 0.2)


func play_sfx_finish() -> void:
	_play_sfx("finish", -3.0, 0.3)


func play_sfx_retry() -> void:
	_play_sfx("retry", -5.0, 0.3)


func play_sfx_gold() -> void:
	await get_tree().create_timer(0.2).timeout
	_play_sfx("gold", -9.0, 0.015)


func play_sfx_round_end(good: bool = true) -> void:
	_play_sfx("round_end_good" if good else "round_end_bad", 0.0, 0.0)


func _get_available_sfx_player() -> AudioStreamPlayer:
	for player in _sfx_players:
		if not player.playing:
			return player
	# all players are busy; return the first one (sfx will be cut off)
	return _sfx_players[0]


func _play_bgm(track_name: String, fade_in: bool = true, volume_db: float = 0.0) -> void:
	if not _bgm_tracks.has(track_name):
		return
	
	if _current_bgm == track_name and _music_player.playing:
		return
	
	_current_bgm = track_name
	_music_player.stream = _bgm_tracks[track_name]
	
	if fade_in:
		_music_player.volume_db = -80
		_music_player.play()
		var tween = create_tween()
		tween.tween_property(_music_player, "volume_db", volume_db, 1.0)
	else:
		_music_player.volume_db = volume_db
		_music_player.play()


func play_bgm_main() -> void:
	_play_bgm("gameplay", false, 0.0)


func stop_music(fade_out: bool = true):
	if not _music_player.playing:
		return
	
	if fade_out:
		var tween = create_tween()
		tween.tween_property(_music_player, "volume_db", -80, 1.0)
		tween.tween_callback(_music_player.stop)
	else:
		_music_player.stop()
	
	_current_bgm = ""


func pause_music():
	_music_player.stream_paused = true


func resume_music():
	_music_player.stream_paused = false


func set_music_volume(volume_db: float):
	_music_player.volume_db = volume_db


func set_sfx_volume(volume_db: float):
	for player in _sfx_players:
		player.volume_db = volume_db
