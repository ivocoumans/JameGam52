extends Node


func _button_start_pressed() -> void:
	SceneManager.start_game()


func _button_help_pressed():
	SceneManager.show_help()
