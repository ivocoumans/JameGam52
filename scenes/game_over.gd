extends Node

@onready var button_audio_on = $UI/CenterContainer/VBoxContainer/HBoxContainer/ButtonAudioOn
@onready var button_audio_off = $UI/CenterContainer/VBoxContainer/HBoxContainer/ButtonAudioOff


func _ready() -> void:
	_toggle_audio_buttons()
	var gold = SceneManager.get_game_data("total_score")
	$UI/CenterContainer/VBoxContainer/Label2.text = "You earned " + str(gold) + " gold!"


func _toggle_audio_buttons() -> void:
	button_audio_on.visible = !Audio.is_muted()
	button_audio_off.visible = Audio.is_muted()


func _button_start_pressed() -> void:
	SceneManager.set_game_data("paused", false)
	SceneManager.restart_game()


func _button_audio_on_pressed() -> void:
	Audio.mute()
	_toggle_audio_buttons()


func _button_audio_off_pressed() -> void:
	Audio.unmute()
	_toggle_audio_buttons()


func _button_quit_pressed() -> void:
	SceneManager.set_game_data("paused", false)
	SceneManager.quit_to_title()
