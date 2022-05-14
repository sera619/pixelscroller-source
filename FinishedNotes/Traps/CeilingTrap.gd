extends Area2D


export (int) var trap_damage
export (float) var cooldown_time


onready var collider = $CollisionShape2D
onready var anim_sprite = $AnimatedSprite
onready var cd_timer = $CooldownTimer

var damage = damage setget set_damage
var can_shoot: bool = true


func _ready():
	set_damage(trap_damage)
	anim_sprite.play('Idle')
	cd_timer.start(cooldown_time)



func shoot():
	anim_sprite.play('Shoot')
	cd_timer.start(cooldown_time)

func set_damage(new_damage):
	damage = new_damage

func _on_AnimatedSprite_frame_changed():
	if anim_sprite.animation == 'Shoot' and anim_sprite.frame == 1:
		collider.disabled = false
	elif anim_sprite.animation == 'Shoot' and anim_sprite.frame == 2:
		collider.disabled = true

func _on_AnimatedSprite_animation_finished():
	if anim_sprite.animation == 'Shoot':
		anim_sprite.play('Transition')
	elif anim_sprite.animation == 'Transition':
		anim_sprite.play('Idle')

func _on_CooldownTimer_timeout():
	shoot()
