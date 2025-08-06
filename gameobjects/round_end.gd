extends CenterContainer


func show_initial() -> void:
	$VBoxContainer/EndText.visible = false
	$VBoxContainer/ContinueText.text = "Press ENTER or CLICK to start"
	$VBoxContainer/ContinueText.visible = true
	visible = true


func show_overlay(round_score: int) -> void:
	$VBoxContainer/ContinueText.visible = false
	
	$VBoxContainer/ContinueText.text = "Press ENTER or CLICK to continue"
	$VBoxContainer/EndText.text = "Game over!"
	if round_score > 0:
		$VBoxContainer/EndText.text = "You earned " + str(round_score) + " gold this round!"
	$VBoxContainer/EndText.visible = true
	visible = true


func hide_overlay() -> void:
	visible = false
	$VBoxContainer/ContinueText.visible = false


func show_continue() -> void:
	$VBoxContainer/ContinueText.visible = true
