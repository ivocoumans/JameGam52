extends Node

@onready var CustomerScene: PackedScene = preload("res://gameobjects/customer.tscn")

var _score = 0
var _current_tier = 1
var _current_round = 0
var _current_timer_display_value = 0


func _ready() -> void:
	_next_customer()
	_update_score(_score)
	_next_round()


func _process(_delta: float) -> void:
	var current_timer_value: int = ceil($RoundTimer.time_left) as int
	if current_timer_value != _current_timer_display_value:
		_current_timer_display_value = current_timer_value
		$UI/TimeLeft.text = "Time Left: " + str(_current_timer_display_value)


func _next_round() -> void:
	_current_round += 1
	
	var customer_timer = 8
	
	if _current_tier > 1:
		$UI/IngredientShelf3/UnicornDust.visible = true
		$UI/IngredientShelf3/PixieWings.visible = true
		$UI/IngredientShelf3/DragonScales.visible = true
		customer_timer = 7
	
	if _current_tier > 2:
		$UI/IngredientShelf2/Thornweed.visible = true
		$UI/IngredientShelf2/EmberRoot.visible = true
		$UI/IngredientShelf3/TrollFat.visible = true
		customer_timer = 5
	
	$NextCustomerTimer.start(customer_timer)


func _input(event) -> void:
	if event.is_action_released("ui_cancel"):
		get_tree().quit()


func _ingredient_selected(type: Ingredients.Types) -> void:
	if !$UI/CenterContainer/BucketPotion.add_ingredient(type):
		return
	$UI/Retry.visible = true
	$UI/Finish.visible = $UI/CenterContainer/BucketPotion.is_finished
	print("Ingredient " + Ingredients.get_text(type) + " added")


func _retry_clicked() -> void:
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
		_score += 1
		_update_score(_score)
		if !$NextCustomerTimer.is_stopped():
			_next_customer()
	
	_update_recipe_preview()
	
	print("Finished potion " + Potions.get_text(potion))


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


func _next_customer() -> void:
	# TODO: clear bucket, or disable it when there are no customers?
	var new_customer: Customer = CustomerScene.instantiate()
	new_customer.type = _get_random_potion()
	new_customer.customer_left.connect(_customer_left)
	new_customer.wait_time = 20 - _current_round
	$UI/CustomerQueue.add_child(new_customer)
	
	_update_recipe_preview()
	
	print("Customer spawned with potion " + Potions.get_text(new_customer.type))


func _update_recipe_preview() -> void:
	# clear container
	for child in $UI/Recipe.get_children():
		child.queue_free()
	
	# find first customer
	var children = $UI/CustomerQueue.get_children()
	if children.size() <= 0:
		$UI/Potion.visible = false
		$UI/NinePatchRect.visible = false
		return
	
	# add potion and ingredients to the container
	var potion_type = (children.get(0) as Customer).type
	var ingredients = Recipes.get_by_potion(potion_type)
	var textures = []
	for ingredient in ingredients:
		textures.append(Ingredients.textures[ingredient])
	$UI/Potion.texture = Potions.textures[potion_type]
	for texture in textures:
		var child = TextureRect.new()
		child.texture = texture
		$UI/Recipe.add_child(child)
	
	# panel
	var margin = 16
	var width = 64 * textures.size() + (margin * 2)
	var height = 128 + (margin * 2)
	$UI/NinePatchRect.size = Vector2(width, height)
	$UI/NinePatchRect.position = Vector2(1280 - 32 - width, 32)
	
	# show elements
	$UI/Potion.visible = true
	$UI/NinePatchRect.visible = true
	
	print("Show recipe for potion " + Potions.get_text(potion_type))


func _customer_left(customer: Customer) -> void:
	# TODO: negative consequences?
	$UI/CustomerQueue.remove_child(customer)
	customer.queue_free()
	_update_recipe_preview()


func _get_random_potion() -> Potions.Types:
	var from = Potions.Types.WeakHealing
	var to = Potions.Types.MinorStrength
	
	if _current_tier > 2:
		to = Potions.Types.BerserkersRage
	elif _current_tier > 1:
		to = Potions.Types.Strength
	
	return randi_range(from, to) as Potions.Types


func _update_score(score: int) -> void:
	$UI/Score.text = "Gold: " + str(score)


func _next_customer_timer_timeout():
	if $UI/CustomerQueue.get_children().size() >= 3:
		# TODO: missed customer
		return
	if $RoundTimer.time_left <= 10:
		print("No more customers")
		$NextCustomerTimer.stop()
	_next_customer()


func _round_timer_timeout():
	$RoundTimer.stop()
	$NextCustomerTimer.stop()
	for customer in $UI/CustomerQueue.get_children():
		customer.queue_free()
	_reset_bucket()
	$UI/GameOver.text = "You earned " + str(_score) + " gold!"
	$UI/GameOverFade.visible = true
	$UI/GameOver.visible = true
