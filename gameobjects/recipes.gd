extends Node

var _recipes = {
	# tier 1
	[Ingredients.Types.Water, Ingredients.Types.Moonbell]: Potions.Types.WeakHealing,
	[Ingredients.Types.Water, Ingredients.Types.Shadowbark]: Potions.Types.WeakAntidote,
	
	# tier 2
	[Ingredients.Types.Wine, Ingredients.Types.CrimsonSage]: Potions.Types.MinorStrength,
	[Ingredients.Types.Water, Ingredients.Types.Moonbell, Ingredients.Types.UnicornDust]: Potions.Types.Healing,
	
	# tier 3
	[Ingredients.Types.Wine, Ingredients.Types.CrimsonSage, Ingredients.Types.DragonScales]: Potions.Types.Strength,
	[Ingredients.Types.Water, Ingredients.Types.Shadowbark, Ingredients.Types.PixieWings]: Potions.Types.Antidote,
	
	# tier 4
	[Ingredients.Types.Water, Ingredients.Types.Thornweed, Ingredients.Types.TrollFat]: Potions.Types.NightVision,
	[Ingredients.Types.Wine, Ingredients.Types.EmberRoot, Ingredients.Types.DragonScales]: Potions.Types.BerserkersRage,
}
var _potion_to_ingredients = {}


func _ready() -> void:
	for ingredient_list in _recipes.keys():
		_potion_to_ingredients[_recipes[ingredient_list]] = ingredient_list

func get_by_ingredients(ingredient_ids: Array[int]) -> Potions.Types:
	var sorted_ids = ingredient_ids.duplicate()
	sorted_ids.sort()
	
	if _recipes.has(sorted_ids):
		return _recipes[sorted_ids]
	return Potions.Types.Invalid


func get_by_potion(potion_type: Potions.Types) -> Array:
	if _potion_to_ingredients.has(potion_type):
		return _potion_to_ingredients[potion_type]
	return []
