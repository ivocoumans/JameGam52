extends Control

@onready var CustomerScene: PackedScene = preload("res://gameobjects/customer.tscn")

const CONTINUE_TIMER = 2

var _total_score = 0
var _round_score = 0
var _current_tier = 1
var _current_round = 0
var _current_timer_display_value = 0


func _ready() -> void:
	SignalBus.unpaused.connect(_unpause)
	# TODO: show game start overlay
	if OS.is_debug_build():
		$RoundTimer.wait_time = 10
	_next_round()


func _unpause() -> void:
	if $RoundTimer.is_stopped():
		_next_round()
		return
	$RoundTimer.paused = false
	$NextCustomerTimer.paused = false
	for customer in $UI/CustomerQueue.get_children():
		customer.unpause_timer()


func _process(_delta: float) -> void:
	if SceneManager.is_paused() == true:
		return
	
	var current_timer_value: int = ceil($RoundTimer.time_left) as int
	if current_timer_value != _current_timer_display_value:
		_current_timer_display_value = current_timer_value
		$UI/TimeLeft.text = "Time Left: " + str(_current_timer_display_value)
	
	if $RoundTimer.time_left <= 10 and !$NextCustomerTimer.is_stopped():
		print("No more customers")
		$NextCustomerTimer.stop()
		_next_customer(true)


func _input(event) -> void:
	if SceneManager.is_paused() == true:
		return
	
	if event.is_action_released("ui_cancel"):
		SceneManager.pause_game()
		$RoundTimer.paused = true
		$NextCustomerTimer.paused = true
		for customer in $UI/CustomerQueue.get_children():
			customer.pause_timer()
		return
	
	if event.is_action_released("ui_accept") and $UI/Finish.visible == true:
		_finish_clicked()
	elif event.is_action_released("game_retry") and $UI/Retry.visible == true:
		_retry_clicked()


func _next_round() -> void:
	_current_round += 1
	_round_score = 0

	# set the current tier
	var tier_thresholds = [0, 3, 5, 7]
	_current_tier = 1
	for i in range(tier_thresholds.size() - 1, 0, -1):
		if _current_round >= tier_thresholds[i]:
			_current_tier = i + 1
			break
	
	var customer_timer = 9 - _current_tier
	
	if _current_tier > 0:
		$UI/IngredientShelf/Water.visible = true
		$UI/IngredientShelf2/Moonbell.visible = true
		$UI/IngredientShelf2/Shadowbark.visible = true
	
	if _current_tier > 1:
		$UI/IngredientShelf/Wine.visible = true
		$UI/IngredientShelf2/CrimsonSage.visible = true
		$UI/IngredientShelf3/UnicornDust.visible = true
	
	if _current_tier > 2:
		$UI/IngredientShelf3/PixieWings.visible = true
		$UI/IngredientShelf3/DragonScales.visible = true
	
	if _current_tier > 3:
		$UI/IngredientShelf2/Thornweed.visible = true
		$UI/IngredientShelf2/EmberRoot.visible = true
		$UI/IngredientShelf3/TrollFat.visible = true
	
	$RoundTimer.start()
	_update_score(_round_score)
	
	# start spawning customers
	$NextCustomerTimer.start(customer_timer)
	_next_customer()


func _ingredient_selected(type: Ingredients.Types) -> void:
	if !$UI/CenterContainer/BucketPotion.add_ingredient(type):
		return
	$UI/Retry.visible = true
	$UI/Finish.visible = $UI/CenterContainer/BucketPotion.is_finished
	print("Ingredient " + Ingredients.get_text(type) + " added")
	Audio.play_sfx_ingredient()


func _retry_clicked() -> void:
	Audio.play_sfx_retry()
	_reset_bucket()


func _reset_bucket() -> void:
	$UI/CenterContainer/BucketPotion.clear_ingredients()
	$UI/Retry.visible = false
	$UI/Finish.visible = false


func _finish_clicked() -> void:
	var potion: Potions.Types = $UI/CenterContainer/BucketPotion.get_potion()
	var is_valid = _validate_potion(potion)
	
	_remove_first_customer()
	_reset_bucket()
	
	if is_valid:
		Audio.play_sfx_gold()
		_round_score += _get_reward_for_potion(potion)
		_update_score(_round_score)
		_next_customer()
	Audio.play_sfx_finish()
	
	_update_recipe_preview()
	
	print("Finished potion " + Potions.get_text(potion))


func _get_reward_for_potion(potion: Potions.Types) -> int:
	# tier 1
	match potion:
		Potions.Types.MinorStrength, Potions.Types.Healing:
			return 2
		Potions.Types.Strength, Potions.Types.Antidote:
			return 3
		Potions.Types.NightVision, Potions.Types.BerserkersRage:
			return 5
	return 1


func _validate_potion(potion: Potions.Types) -> bool:
	if $UI/CustomerQueue.get_children().size() <= 0:
		return false
	return ($UI/CustomerQueue.get_child(0) as Customer).type == potion


func _remove_first_customer() -> void:
	if $UI/CustomerQueue.get_children().size() <= 0:
		return
	var child = $UI/CustomerQueue.get_children().get(0)
	$UI/CustomerQueue.remove_child(child)
	child.queue_free()


func _next_customer(skip_timer = false) -> void:
	if $RoundTimer.time_left <= 10 and !skip_timer:
		return
	
	# TODO: clear bucket, or disable it when there are no customers?
	var new_customer: Customer = CustomerScene.instantiate()
	new_customer.type = _get_random_potion()
	new_customer.customer_left.connect(_customer_left)
	new_customer.wait_time = 20 - _current_tier
	$UI/CustomerQueue.add_child(new_customer)
	
	_update_recipe_preview()
	
	print("Customer spawned with potion " + Potions.get_text(new_customer.type))


func _update_recipe_preview() -> void:
	# clear container
	for child in $UI/RecipePreview/Recipe.get_children():
		child.queue_free()
	
	# find first customer
	var children = $UI/CustomerQueue.get_children()
	if children.size() <= 0:
		$UI/RecipePreview.visible = false
		return
	
	# add potion and ingredients to the container
	var potion_type = (children.get(0) as Customer).type
	var ingredients = Recipes.get_by_potion(potion_type)
	var textures = []
	for ingredient in ingredients:
		textures.append(Ingredients.textures[ingredient])
	$UI/RecipePreview/Potion.texture = Potions.textures[potion_type]
	for texture in textures:
		var child = TextureRect.new()
		child.texture = texture
		$UI/RecipePreview/Recipe.add_child(child)
	
	# panel
	var margin = 16
	var width = 64 * textures.size() + (margin * 2)
	var height = 128 + (margin * 2)
	$UI/RecipePreview/NinePatchRect.size = Vector2(width, height)
	$UI/RecipePreview/NinePatchRect.position = Vector2(1280 - 32 - width, 32)
	
	# show elements
	$UI/RecipePreview.visible = true
	
	print("Show recipe for potion " + Potions.get_text(potion_type))


func _customer_left(customer: Customer) -> void:
	# TODO: negative consequences?
	$UI/CustomerQueue.remove_child(customer)
	customer.queue_free()
	_update_recipe_preview()


func _get_random_potion() -> Potions.Types:
	var from = Potions.Types.WeakHealing
	var to = Potions.Types.WeakAntidote
	
	if _current_tier > 3:
		to = Potions.Types.BerserkersRage
	elif _current_tier > 2:
		to = Potions.Types.Antidote
	elif _current_tier > 1:
		to = Potions.Types.Healing
	
	return randi_range(from, to) as Potions.Types


func _update_score(score: int) -> void:
	$UI/Score.text = "Gold: " + str(score)


func _next_customer_timer_timeout():
	if $UI/CustomerQueue.get_children().size() >= 3:
		# TODO: missed customer
		return
	_next_customer()


func _round_timer_timeout():
	$RoundTimer.stop()
	$NextCustomerTimer.stop()
	for customer in $UI/CustomerQueue.get_children():
		customer.queue_free()
	_reset_bucket()
	
	_total_score += _round_score
	SceneManager.set_game_data("total_score", _total_score)
	SceneManager.set_game_data("round_score", _round_score)
	
	if _round_score > 0:
		SceneManager.show_round_end()
	else:
		SceneManager.show_game_over()
	Audio.play_sfx_round_end(_round_score > 0)
