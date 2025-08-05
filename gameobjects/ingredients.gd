extends Node

enum Types {
	# liquid base
	Water = 0,
	Wine = 1,
	
	# herbs
	Moonbell = 2,
	CrimsonSage = 3,
	Thornweed = 4,
	EmberRoot = 5,
	Shadowbark = 6,
	
	# reagents
	UnicornDust = 7,
	DragonScales = 8,
	PixieWings = 9,
	TrollFat = 10
}

@onready var textures: Dictionary = {
	Types.Water: preload("res://assets/ingredient_water.png"),
	Types.Wine: preload("res://assets/ingredient_wine.png"),
	Types.Moonbell: preload("res://assets/ingredient_moonbell.png"),
	Types.CrimsonSage: preload("res://assets/ingredient_crimsonsage.png"),
	Types.Thornweed: preload("res://assets/ingredient_thornweed.png"),
	Types.EmberRoot: preload("res://assets/ingredient_emberroot.png"),
	Types.Shadowbark: preload("res://assets/ingredient_shadowbark.png"),
	Types.UnicornDust: preload("res://assets/ingredient_unicorndust.png"),
	Types.DragonScales: preload("res://assets/ingredient_dragonscales.png"),
	Types.PixieWings: preload("res://assets/ingredient_pixiewings.png"),
	Types.TrollFat: preload("res://assets/ingredient_trollfat.png")
}


func get_text(type: Types) -> String:
	return Ingredients.Types.keys()[type]
