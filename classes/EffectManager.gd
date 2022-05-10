extends Node2D

onready var melee_hit = $MeleeHit

func melee_effect():
	melee_hit.visible = true
	melee_hit.play('Melee')

func _on_MeleeHit_animation_finished():
	melee_hit.set_deferred('visible',false)
