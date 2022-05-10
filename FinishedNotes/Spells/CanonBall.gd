extends Area2D


var damage = damage setget set_damage



func set_damage(value):
	damage = value

func _ready():
	fly()

func fly():
	$AnimationPlayer.play("Fly")

func _on_CanonBall_area_entered(area):
	if area.is_in_group('player_hitbox'):
		self.call_deferred('queue_free')
