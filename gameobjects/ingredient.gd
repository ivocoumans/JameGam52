extends TextureButton

@export var type: Ingredients.Types

signal ingredient_selected(type: Ingredients.Types)

var _initial_scale: Vector2
var _initial_modulate: Color
var _hover_tween: Tween


func _ready() -> void:
	_initial_scale = scale
	_initial_modulate = modulate
	if type != null:
		_set_textures(Ingredients.textures[type])


func _set_textures(new_texture: Texture2D) -> void:
	texture_normal = new_texture
	texture_pressed = new_texture
	texture_hover = new_texture
	texture_disabled = new_texture
	texture_focused = new_texture


func _button_down() -> void:
	modulate = Color.GRAY
	create_tween().tween_property(self, "modulate", Color.WHITE, 0.1)
	ingredient_selected.emit(type)


func _mouse_entered():
	if _hover_tween:
		_hover_tween.kill()
	
	_hover_tween = create_tween()
	_hover_tween.set_parallel(true)
	_hover_tween.tween_property(self, "scale", _initial_scale * 1.1, 0.1)
	_hover_tween.tween_property(self, "modulate", Color.WHITE * 1.2, 0.1)


func _mouse_exited():
	if _hover_tween:
		_hover_tween.kill()
	
	_hover_tween = create_tween()
	_hover_tween.set_parallel(true)
	_hover_tween.tween_property(self, "scale", _initial_scale, 0.1)
	_hover_tween.tween_property(self, "modulate", _initial_modulate, 0.1)
