extends Area2D


export(int) var enemy_damage: int = 2
var damage = enemy_damage setget set_damage


func _ready():
	set_damage(enemy_damage)

func set_damage(new_damage):
	damage = new_damage
