extends Node

enum Types {
	Empty = 0,
	Invalid = 1,
	
	# liquid base
	Water = 2,
	Wine = 3,
	
	# potions - tier 1
	WeakHealing = 4,
	WeakAntidote = 5,
	
	# tier 2
	MinorStrength = 6,
	Healing = 7,
	
	# tier 3
	Strength = 8,
	Antidote = 9,
	
	# tier 4
	NightVision = 10,
	BerserkersRage = 11,
}

@onready var textures: Dictionary = {
	Types.WeakHealing: preload("res://assets/potion_weakhealing.png"),
	Types.WeakAntidote: preload("res://assets/potion_weakantidote.png"),
	Types.MinorStrength: preload("res://assets/potion_minorstrength.png"),
	Types.Healing: preload("res://assets/potion_healing.png"),
	Types.Antidote: preload("res://assets/potion_antidote.png"),
	Types.Strength: preload("res://assets/potion_strength.png"),
	Types.NightVision: preload("res://assets/potion_nightvision.png"),
	Types.BerserkersRage: preload("res://assets/potion_berserkersrage.png")
}


func get_text(type: Types) -> String:
	return Potions.Types.keys()[type]
