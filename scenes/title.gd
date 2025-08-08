extends Node

@onready var button_audio_on = $UI/ElementsCenter/VBoxContainer/HBoxContainer/ButtonAudioOn
@onready var button_audio_off = $UI/ElementsCenter/VBoxContainer/HBoxContainer/ButtonAudioOff


func _ready() -> void:
	if OS.is_debug_build():
		Audio.mute()
	Audio.play_bgm_main()
	_toggle_audio_buttons()


func _toggle_audio_buttons() -> void:
	button_audio_on.visible = !Audio.is_muted()
	button_audio_off.visible = Audio.is_muted()


func _input(event) -> void:
	if SceneManager.current_scene != SceneManager.Scene.TITLE:
		return
	
	if event.is_action_released("ui_cancel"):
		get_tree().quit()


func _button_start_pressed() -> void:
	SceneManager.show_game_start()


func _button_audio_on_pressed() -> void:
	Audio.mute()
	_toggle_audio_buttons()


func _button_audio_off_pressed() -> void:
	Audio.unmute()
	_toggle_audio_buttons()


func _button_quit_pressed() -> void:
	get_tree().quit()


func _button_help_pressed():
	SceneManager.show_help()
