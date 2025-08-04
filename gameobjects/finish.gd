extends TextureButton

signal finish_clicked


func _ready() -> void:
	visible = false


func _button_pressed() -> void:
	finish_clicked.emit()
