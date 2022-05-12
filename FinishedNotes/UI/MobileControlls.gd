extends Node
class_name MobileController


onready var action_controller = $ActionPad



func _on_XTouchButton_pressed():
	Input.action_press("interact")
	if GameManager.player.velocity.x > 0 or GameManager.player.velocity.x < 0:
		Input.action_press("slide")
