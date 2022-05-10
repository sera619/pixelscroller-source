extends Area2D

export var damage := 3
onready var animPlayer = $SpearTrap/AnimationPlayer

func _ready():
	animPlayer.play("Hit")


