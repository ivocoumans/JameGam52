extends Node

enum Types {
	Empty = 0,
	Invalid = 1,
	
	# liquid base
	Water = 2,
	Wine = 3,
	
	# potions
	WeakHealing = 4,
	WeakAntidote = 5,
	MinorStrength = 6,
	Healing = 7,
	Antidote = 8,
	Strength = 9,
	NightVision = 10,
	BerserkersRage = 11,
}

@onready var textures: Dictionary = {
	Types.WeakHealing: preload("res://assets/potion_healing.png"),
	Types.WeakAntidote: preload("res://assets/potion_antidote.png"),
	Types.MinorStrength: preload("res://assets/potion_strength.png"),
	
	# TODO: add 1 star for quality/difficulty
	Types.Healing: preload("res://assets/potion_healing.png"),
	Types.Antidote: preload("res://assets/potion_antidote.png"),
	Types.Strength: preload("res://assets/potion_strength.png"),
	
	# TODO: add 2 stars for quality/difficulty
	Types.NightVision: preload("res://assets/potion_nightvision.png"),
	Types.BerserkersRage: preload("res://assets/potion_berserkersrage.png")
}


func get_text(type: Types) -> String:
	return Potions.Types.keys()[type]
