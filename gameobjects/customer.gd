class_name Customer
extends Control

@export var type: Potions.Types

signal customer_left(customer: Customer)

var _current_timer_display_value = 0
var wait_time = 20


func _ready() -> void:
	var is_valid: bool = type != null
	
	$OrderBubble.visible = is_valid
	$Potion.visible = is_valid
	$TimerDisplay.visible = false
	
	_set_textures(Potions.textures[type])
	
	if is_valid:
		$Timer.start(wait_time)
		_current_timer_display_value = ceil($Timer.time_left) as int


func _process(_delta: float) -> void:
	var current_timer_value: int = ceil($Timer.time_left) as int
	if current_timer_value <= 5 and $TimerDisplay.visible == false: 
		$TimerDisplay.visible = true
	
	if $TimerDisplay.visible == false:
		return
	
	if current_timer_value != _current_timer_display_value:
		_current_timer_display_value = current_timer_value
		$TimerDisplay.text = str(_current_timer_display_value)


func _set_textures(new_texture: Texture2D) -> void:
	$Potion.texture = new_texture


func _timer_timeout():
	customer_left.emit(self)
