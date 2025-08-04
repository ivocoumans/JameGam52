extends Node

@onready var CustomerScene: PackedScene = preload("res://gameobjects/customer.tscn")

var _score = 0


func _ready() -> void:
	_next_customer()
	$NextCustomerTimer.start(randi_range(3, 7))
	_update_score(_score)


func _input(event) -> void:
	if event.is_action_released("ui_cancel"):
		get_tree().quit()


func _ingredient_selected(type: Globals.IngredientType) -> void:
	$UI/CenterContainer/BucketPotion.add_ingredient(type)
	$UI/Retry.visible = true
	$UI/Finish.visible = $UI/CenterContainer/BucketPotion.is_finished


func _get_ingredient_name(type: Globals.IngredientType) -> String:
	match type:
		Globals.IngredientType.Blue:
			return "Blue"
		Globals.IngredientType.Red:
			return "Red"
		Globals.IngredientType.Yellow:
			return "Yellow"
	return "None"


func _retry_clicked() -> void:
	_reset_bucket()


func _reset_bucket() -> void:
	$UI/CenterContainer/BucketPotion.clear_ingredients()
	$UI/Retry.visible = false
	$UI/Finish.visible = false


func _finish_clicked() -> void:
	var potion: Globals.PotionType = $UI/CenterContainer/BucketPotion.get_potion()
	if _validate_potion(potion):
		_score += 1
		_update_score(_score)
		if $NextCustomerTimer.is_stopped() == false:
			_next_customer()
	
	_remove_first_customer()
	_reset_bucket()


func _validate_potion(potion: Globals.PotionType) -> bool:
	if $UI/CustomerQueue.get_children().size() <= 0:
		return false
	return ($UI/CustomerQueue.get_child(0) as Customer).type == potion


func _remove_first_customer() -> void:
	if $UI/CustomerQueue.get_children().size() > 0:
		$UI/CustomerQueue.get_children().pop_front().queue_free()


func _next_customer() -> void:
	# TODO: clear bucket, or disable it when there are no customers?
	var new_customer: Customer = CustomerScene.instantiate()
	new_customer.type = _get_random_potion()
	new_customer.customer_left.connect(_customer_left)
	$UI/CustomerQueue.add_child(new_customer)


func _customer_left(leaving_customer: Customer) -> void:
	# TODO: negative consequences?
	# TODO: pass the customer to despawn as later customers might have different timers
	for customer in $UI/CustomerQueue.get_children():
		if customer == leaving_customer:
			customer.queue_free()


func _get_random_potion() -> Globals.PotionType:
	# TODO: simplify or add conditions
	var valid_types = []
	for i in range(3):
		valid_types.append(i)
	return valid_types.pick_random()


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
