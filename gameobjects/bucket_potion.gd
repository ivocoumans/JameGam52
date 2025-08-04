extends TextureRect

@onready var texture_green: Texture2D = preload("res://assets/potion_green.png")
@onready var texture_orange: Texture2D = preload("res://assets/potion_orange.png")
@onready var texture_purple: Texture2D = preload("res://assets/potion_purple.png")
@onready var texture_blue: Texture2D = preload("res://assets/ingredient_blue.png")
@onready var texture_red: Texture2D = preload("res://assets/ingredient_red.png")
@onready var texture_yellow: Texture2D = preload("res://assets/ingredient_yellow.png")
@onready var texture_black: Texture2D = preload("res://assets/potion_black.png")

var is_finished: bool = false
var ingredient_ids: Array[int]

var recipes = {
	[0, 1]: 2,
	[0, 2]: 0,
	[1, 2]: 1
}

@onready var ingredient_textures = [
	texture_blue,
	texture_red,
	texture_yellow
]

@onready var potion_textures = [
	texture_green,
	texture_orange,
	texture_purple
]


func add_ingredient(id: int) -> void:
	ingredient_ids.append(id)
	texture = _get_result_texture()


func clear_ingredients() -> void:
	ingredient_ids = []
	texture = null
	print("Bucket cleared")


func get_potion() -> Globals.PotionType:
	var sorted_ids = ingredient_ids.duplicate()
	sorted_ids.sort()
	
	if recipes.has(sorted_ids):
		return recipes[sorted_ids]
	return Globals.PotionType.Invalid


func _get_result_texture() -> Texture2D:
	match ingredient_ids.size():
		1:
			return ingredient_textures[ingredient_ids[0]]
		2:
			var potion_type = get_potion()
			if potion_type == Globals.PotionType.Invalid:
				is_finished = false
				return texture_black
			is_finished = true
			return potion_textures[potion_type]
		_:
			is_finished = false
			return texture_black
