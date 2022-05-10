extends Node

onready var animplayer = $CanvasLayer/AnimationPlayer


func _ready():
	animplayer.play("Intro")

func start_game():
	get_tree().change_scene("res://World/MainMenu.tscn")
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			start_game()
	if event is InputEventScreenTouch:
		if event.pressed:
			start_game()
