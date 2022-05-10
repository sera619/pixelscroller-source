extends Area2D

export (int) var trap_damage : int = 2
onready var animPlayer = $AnimationPlayer
onready var sprite = $Sprite

var damage = trap_damage setget set_damage



func _ready():
	set_damage(trap_damage)


func hit_left():
	animPlayer.play('Blade_l')


func hit_right():
	animPlayer.play("Blade_r")
	
	
func set_damage(new_damage):
	damage = new_damage

func _on_BoltTrap_body_entered(body):
	if body.name != 'Player':
		return
	else:
		body.take_damage(damage)
		self.call_deferred('queue_free')

func _on_AnimationPlayer_animation_finished(anim_name):
	self.call_deferred('queue_free')
