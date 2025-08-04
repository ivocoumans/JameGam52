extends Node

@onready var CustomerScene: PackedScene = preload("res://gameobjects/customer.tscn")

var _score = 0


func _input(event) -> void:
	if event.is_action_released("ui_cancel"):
		get_tree().quit()


func _ingredient_selected(type: Globals.IngredientType) -> void:
	print("Ingredient clicked " + _get_ingredient_name(type))
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
	$UI/CenterContainer/BucketPotion.clear_ingredients()
	$UI/Retry.visible = false
	$UI/Finish.visible = false


func _finish_clicked() -> void:
	var potion: Globals.PotionType = $UI/CenterContainer/BucketPotion.get_potion()
	if _validate_potion(potion):
		_score += 1
		_update_score(_score)
		print("Score: " + str(_score))
	
	$UI/CenterContainer/BucketPotion.clear_ingredients()
	$UI/Retry.visible = false
	$UI/Finish.visible = false
	
	_next_customer(potion)

func _validate_potion(potion: Globals.PotionType) -> bool:
	return ($UI/CustomerQueue.get_child(0) as Customer).type == potion


func _next_customer(potion: Globals.PotionType) -> void:
	$UI/CustomerQueue.get_children().pop_front().queue_free()
	var new_customer: Customer = CustomerScene.instantiate()
	new_customer.type = _get_random_potion(potion)
	$UI/CustomerQueue.add_child(new_customer)


func _get_random_potion(exclude: Globals.PotionType) -> Globals.PotionType:
	var valid_types = []
	for i in range(3):
		if i != exclude as int:
			valid_types.append(i)
	return valid_types.pick_random()


func _update_score(score: int) -> void:
	$UI/Score.text = "Score " + str(score)
