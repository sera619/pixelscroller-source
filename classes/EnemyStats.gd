class_name EnemyStats
extends Node


export(int) var max_health: int = 10
var health = max_health setget set_health

export(int) var max_shield: int = 5
var shield = max_shield setget set_shield

export(int) var max_damage: int = 2
var damage = max_damage setget set_damage


signal health_changed
signal shield_changed
signal damage_changed


func set_health(new_health):
	health = clamp(new_health, 0 , max_health)
	emit_signal("health_changed")

func set_shield(new_shield):
	shield = clamp(new_shield,0, max_shield)
	emit_signal("shield_changed")
	

func set_damage(new_damage):
	damage = clamp(new_damage, 0 , max_damage)
	emit_signal("damage_changed")
