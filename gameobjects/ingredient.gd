extends TextureButton

@onready var texture_blue: Texture2D = preload("res://assets/ingredient_blue.png")
@onready var texture_red: Texture2D = preload("res://assets/ingredient_red.png")
@onready var texture_yellow: Texture2D = preload("res://assets/ingredient_yellow.png")

@export var type: Globals.IngredientType

signal ingredient_selected(type: Globals.IngredientType)


func _ready() -> void:
	match type:
		Globals.IngredientType.Blue:
			_set_textures(texture_blue)
		Globals.IngredientType.Red:
			_set_textures(texture_red)
		Globals.IngredientType.Yellow:
			_set_textures(texture_yellow)


func _set_textures(new_texture: Texture2D) -> void:
	texture_normal = new_texture
	texture_pressed = new_texture
	texture_hover = new_texture
	texture_disabled = new_texture
	texture_focused = new_texture


func _button_pressed() -> void:
	ingredient_selected.emit(type)
