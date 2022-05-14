extends Node
class_name MobileController


onready var action_controller = $ActionPad
onready var z_button = $ActionPad/ZTouchButton


func _ready():
	GameManager.register_mobilecontroller(self)

func show_z_btn():
	z_button.visible = true

func hide_z_btn():
	z_button.visible = false


func _on_XTouchButton_pressed():
	if GameManager.player.velocity.x > 0 or GameManager.player.velocity.x < 0:
		Input.action_press("slide")

