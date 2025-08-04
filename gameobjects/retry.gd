extends TextureButton

signal retry_clicked


func _ready() -> void:
	visible = false


func _button_pressed() -> void:
	retry_clicked.emit()
