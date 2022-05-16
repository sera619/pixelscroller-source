extends Area2D

onready var anim_player = $AnimationPlayer
export (int) var trap_damage

var damage = damage setget set_damage


func _ready():
	set_damage(trap_damage)
	anim_player.play("loop")

func set_damage(new_damage):
	damage = new_damage
