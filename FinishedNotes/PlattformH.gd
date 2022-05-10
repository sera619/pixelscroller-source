extends Node2D

onready var animPlayer = $AnimationPlayer

func move():
	animPlayer.play("up")
