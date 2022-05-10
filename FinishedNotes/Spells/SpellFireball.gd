extends Area2D


export var spellDamage: int
onready var animPlayer = $AnimationPlayer
var damage: int

func _ready():
	damage = spellDamage






func _on_SpellFireball_area_entered(area):
	if area.is_in_group('player_hitbox'):
		call_deferred('queue_free')
	else:
		pass
