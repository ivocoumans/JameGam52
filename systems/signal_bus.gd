extends Node

signal unpaused


func emit_unpaused() -> void:
	unpaused.emit()
