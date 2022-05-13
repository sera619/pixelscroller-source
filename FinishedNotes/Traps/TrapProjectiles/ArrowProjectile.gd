extends Area2D


var damage = damage setget set_damage
onready var animPlayer = $AnimationPlayer



func fly_left():
	animPlayer.play("fly_left")

func fly_right():
	animPlayer.play("fly_right")


func set_damage(new_damage):
	damage = new_damage 


func _on_ArrowProjectile_area_entered(area):
	if area.is_in_group('player_hitbox'):
		self.call_deferred('queue_free')
