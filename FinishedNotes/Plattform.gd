extends Node2D


var is_moving: bool

onready var animplayer = $AnimationPlayer

func _ready():
	animplayer.play("horizontal")
