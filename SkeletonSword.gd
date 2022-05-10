extends Area2D

signal damage_changed
export var max_dmg: int = 2
var damage: int  = max_dmg setget set_dmg



func set_dmg(value):
	damage = value
	emit_signal('damage_changed')
	
