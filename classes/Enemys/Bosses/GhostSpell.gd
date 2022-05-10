extends Area2D
signal player_hitted

onready var sprite = $AnimatedSprite
onready var animPlayer = $AnimationPlayer
var damage: int setget set_damage

func _ready():
	sprite.play('spawn')


func _on_GhostSpell_area_entered(area):
	if area.is_in_group('player_hitbox'):
		emit_signal("player_hitted")
		sprite.play('explode')

func set_damage(value: int):
	damage = value

func _on_AnimatedSprite_animation_finished():
	if sprite.animation == 'explode':
		self.queue_free()
	elif sprite.animation == 'spawn':
		sprite.play('move')
		animPlayer.play("moving")

func _on_GhostSpell_body_entered(body):
	self.queue_free()
