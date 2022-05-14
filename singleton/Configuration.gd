extends Node
class_name Config

var user_device = null
var game_version = "0.7.1 "


func _init():
	get_user_device()

func get_user_device():
	user_device = OS.get_name()
	print('>>> CONFIG: Player used device: ' + user_device)
