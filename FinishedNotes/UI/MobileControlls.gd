extends Node
class_name MobileController


onready var action_controller = $ActionPad





func _on_AButton_pressed():
	Input.action_press("jump")


func _on_XButton_pressed():
	Input.action_press("interact")



func _on_YButton_pressed():
	Input.action_press("dash_attack")


func _on_BButton_pressed():
	Input.action_press("attack")
