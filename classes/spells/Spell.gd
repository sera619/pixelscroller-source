extends Area2D

export(int) var spell_damage

var damage = spell_damage setget set_spelldamage
onready var animPlayer = $AnimationPlayer


func _ready():
	set_spelldamage(spell_damage)

func set_spelldamage(new_damage):
	damage = new_damage

func fly_right():
	animPlayer.play("fly_right")

func fly_left():
	animPlayer.play("fly_left")

func _on_SpellFireball_area_entered(area):
	if !area.is_in_group('player_hitbox'):
		return
	else:
		call_deferred('queue_free')
		
