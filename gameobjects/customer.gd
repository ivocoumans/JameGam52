class_name Customer
extends Control

@onready var texture_green: Texture2D = preload("res://assets/potion_green.png")
@onready var texture_orange: Texture2D = preload("res://assets/potion_orange.png")
@onready var texture_purple: Texture2D = preload("res://assets/potion_purple.png")

@export var type: Globals.PotionType

signal customer_left(customer: Customer)

var current_timer_display_value = 0


func _ready() -> void:
	var is_valid: bool = type != Globals.PotionType.Invalid
	
	$OrderBubble.visible = is_valid
	$Potion.visible = is_valid
	$TimerDisplay.visible = false
	
	match type:
		Globals.PotionType.Green:
			_set_textures(texture_green)
		Globals.PotionType.Orange:
			_set_textures(texture_orange)
		Globals.PotionType.Purple:
			_set_textures(texture_purple)
	
	if is_valid:
		$Timer.start(randi_range(7, 15))
		current_timer_display_value = ceil($Timer.time_left) as int


func _process(_delta: float) -> void:
	var current_timer_value: int = ceil($Timer.time_left) as int
	if current_timer_value <= 5 and $TimerDisplay.visible == false: 
		$TimerDisplay.visible = true
	
	if $TimerDisplay.visible == false:
		return
	
	if current_timer_value != current_timer_display_value:
		current_timer_display_value = current_timer_value
		$TimerDisplay.text = str(current_timer_display_value)


func _set_textures(new_texture: Texture2D) -> void:
	$Potion.texture = new_texture


func _timer_timeout():
	customer_left.emit(self)
