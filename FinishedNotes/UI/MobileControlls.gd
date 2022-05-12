extends Node
class_name MobileController


onready var action_controller = $ActionPad
onready var z_button = $ActionPad/ZTouchButton


func _read():
	GameManager.register_mobilecontroller(self)

func show_z_btn():
	z_button.show()


func _on_XTouchButton_pressed():
	Input.action_press("interact")
	if GameManager.player.velocity.x > 0 or GameManager.player.velocity.x < 0:
		Input.action_press("slide")


func _on_ZTouchButton_pressed():
	Input.action_press("sword_attack")
	z_button.hide()
