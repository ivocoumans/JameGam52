class_name Customer
extends TextureRect

@onready var texture_green: Texture2D = preload("res://assets/potion_green.png")
@onready var texture_orange: Texture2D = preload("res://assets/potion_orange.png")
@onready var texture_purple: Texture2D = preload("res://assets/potion_purple.png")

@export var type: Globals.PotionType


func _ready() -> void:
	var text = ""
	match type:
		Globals.PotionType.Green:
			_set_textures(texture_green)
			text = "Green"
		Globals.PotionType.Orange:
			_set_textures(texture_orange)
			text = "Orange"
		Globals.PotionType.Purple:
			_set_textures(texture_purple)
			text = "Purple"
	print(text + " potion spawned")


func _set_textures(new_texture: Texture2D) -> void:
	texture = new_texture
