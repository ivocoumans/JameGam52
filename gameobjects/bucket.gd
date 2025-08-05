extends Node

@onready var textures: Dictionary = {
	Potions.Types.Empty: preload("res://assets/bucket_empty.png"),
	
	Potions.Types.Water: preload("res://assets/bucket_water.png"),
	Potions.Types.Wine: preload("res://assets/bucket_wine.png"),
	
	Potions.Types.WeakHealing: preload("res://assets/bucket_healing.png"),
	Potions.Types.WeakAntidote: preload("res://assets/bucket_antidote.png"),
	Potions.Types.MinorStrength: preload("res://assets/bucket_strength.png"),
	
	# TODO: should bucket textures be different for higher tier potions?
	Potions.Types.Healing: preload("res://assets/bucket_healing.png"),
	Potions.Types.Antidote: preload("res://assets/bucket_antidote.png"),
	Potions.Types.Strength: preload("res://assets/bucket_strength.png"),
	
	Potions.Types.NightVision: preload("res://assets/bucket_nightvision.png"),
	Potions.Types.BerserkersRage: preload("res://assets/bucket_berserkersrage.png"),
	
	Potions.Types.Invalid: preload("res://assets/bucket_invalid.png"),
}
