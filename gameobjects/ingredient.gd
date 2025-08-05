extends TextureButton

@export var type: Ingredients.Types

signal ingredient_selected(type: Ingredients.Types)


func _ready() -> void:
	if type != null:
		_set_textures(Ingredients.textures[type])


func _set_textures(new_texture: Texture2D) -> void:
	texture_normal = new_texture
	texture_pressed = new_texture
	texture_hover = new_texture
	texture_disabled = new_texture
	texture_focused = new_texture


func _button_pressed() -> void:
	ingredient_selected.emit(type)
