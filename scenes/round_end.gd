extends Node

@onready var button_audio_on = $UI/CenterContainer/VBoxContainer/HBoxContainer/ButtonAudioOn
@onready var button_audio_off = $UI/CenterContainer/VBoxContainer/HBoxContainer/ButtonAudioOff
@onready var equals_texture = preload("res://assets/equals.png")


func _ready() -> void:
	_toggle_audio_buttons()
	var gold = SceneManager.get_game_data("round_score")
	$UI/CenterContainer/VBoxContainer/Label2.text = "You earned " + str(gold) + " gold!"
	_set_tier_info()


func _toggle_audio_buttons() -> void:
	button_audio_on.visible = !Audio.is_muted()
	button_audio_off.visible = Audio.is_muted()


func _button_start_pressed() -> void:
	_resume_game()


func _resume_game() -> void:
	SceneManager.set_game_data("paused", false)
	SceneManager.continue_from_round_end()
	SignalBus.unpaused.emit()


func _button_audio_on_pressed() -> void:
	Audio.mute()
	_toggle_audio_buttons()


func _button_audio_off_pressed() -> void:
	Audio.unmute()
	_toggle_audio_buttons()


func _button_quit_pressed() -> void:
	SceneManager.set_game_data("paused", false)
	SceneManager.quit_to_title()


func _set_tier_info() -> void:
	$UI/TierInfo.visible = false
	
	var current_round = SceneManager.get_game_data("current_round")
	var current_tier = SceneManager.get_game_data("current_tier")
	
	var tier_thresholds = [0, 3, 5, 7]
	var next_tier = 1
	for i in range(tier_thresholds.size() - 1, 0, -1):
		if current_round + 1 >= tier_thresholds[i]:
			next_tier = i + 1
			break
	
	if next_tier <= current_tier:
		return
	
	# show info for next_tier
	var potions = []
	if next_tier == 2:
		potions.append(Potions.Types.MinorStrength)
		potions.append(Potions.Types.Healing)
	elif next_tier == 3:
		potions.append(Potions.Types.Strength)
		potions.append(Potions.Types.Antidote)
	elif next_tier == 4:
		potions.append(Potions.Types.NightVision)
		potions.append(Potions.Types.BerserkersRage)
	
	for child in $UI/TierInfo/VBoxContainer.get_children():
		child.queue_free()
	
	for potion in potions:
		var textures = []
		
		var ingredients = Recipes.get_by_potion(potion)
		for ingredient in ingredients:
			textures.append(Ingredients.textures[ingredient])
		
		textures.append(equals_texture)
		textures.append(Potions.textures[potion])
		
		var container = HBoxContainer.new()
		container.alignment = BoxContainer.ALIGNMENT_END
		container.custom_minimum_size = Vector2(256, 48)
		for texture in textures:
			var child = TextureRect.new()
			child.texture = texture
			child.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			container.add_child(child)
		$UI/TierInfo/VBoxContainer.add_child(container)
	
	$UI/TierInfo.visible = true
