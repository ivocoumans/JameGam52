extends TextureRect

var is_finished: bool = false
var ingredient_ids: Array[int]


func add_ingredient(ingredient: Ingredients.Types) -> bool:
	# prevent duplicates
	if ingredient_ids.has(ingredient):
		return false

	# prevent conflicting ingredient types
	var duplicate_liquid_base = _is_liquid_base(ingredient) and ingredient_ids.any(_is_liquid_base)
	var duplicate_herb = _is_herb(ingredient) and ingredient_ids.any(_is_herb)
	var duplicate_reagent = _is_reagent(ingredient) and ingredient_ids.any(_is_reagent)
	if duplicate_liquid_base or duplicate_herb or duplicate_reagent:
		return false
	
	ingredient_ids.append(ingredient)
	texture = _get_result_texture()
	return true


func _is_liquid_base(ingredient: Ingredients.Types) -> bool:
	return ingredient in [Ingredients.Types.Water, Ingredients.Types.Wine]


func _is_herb(ingredient: Ingredients.Types) -> bool:
	return ingredient in [Ingredients.Types.Moonbell, Ingredients.Types.CrimsonSage, Ingredients.Types.Thornweed, Ingredients.Types.EmberRoot, Ingredients.Types.Shadowbark]


func _is_reagent(ingredient: Ingredients.Types) -> bool:
	return ingredient in [Ingredients.Types.UnicornDust, Ingredients.Types.PixieWings, Ingredients.Types.DragonScales, Ingredients.Types.TrollFat]


func clear_ingredients() -> void:
	ingredient_ids = []
	texture = null


func get_potion() -> Potions.Types:
	return Recipes.get_by_ingredients(ingredient_ids)


func _get_result_texture() -> Texture2D:
	var ingredient_count = ingredient_ids.size()
	
	is_finished = false
	
	# handle empty bucket, or invalid ingredient counts
	if ingredient_count == 0:
		print("Bucket is empty")
		return Bucket.textures[Potions.Types.Empty]
	if ingredient_count > 4:
		print("Bucket has too many ingredients")
		return Bucket.textures[Potions.Types.Invalid]
	
	# check for a valid potion
	if ingredient_count >= 2:
		var potion_type = get_potion()
		if potion_type != Potions.Types.Invalid:
			is_finished = true
			print("Bucket has potion " + Potions.get_text(potion_type))
			return Bucket.textures[potion_type]
	
	# show the liquid base or an empty bucket
	return _get_liquidbase_texture()


func _get_liquidbase_texture() -> Texture2D:
	if ingredient_ids.any(func(id): return id == Ingredients.Types.Water):
		print("Bucket has water base")
		return Bucket.textures[Potions.Types.Water]
	if ingredient_ids.any(func(id): return id == Ingredients.Types.Wine):
		print("Bucket has wine base")
		return Bucket.textures[Potions.Types.Wine]
	print("Bucket is empty")
	return Bucket.textures[Potions.Types.Empty]
