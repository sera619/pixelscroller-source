extends Node2D

onready var animSprite = $AnimatedSprite
onready var atk_timer = $AtkTimer
onready var spawn_pos = $Position2D

export var canon_damage: int = 2
export (float) var cooldown: float = 3.5
export (PackedScene) var canon_ball



var can_shoot: bool = true


func _ready():
	animSprite.play('Idle')

func _process(delta):
	if !can_shoot:
		return
	else:
		can_shoot = false
		shoot()


func shoot():
	var ball = canon_ball.instance()
	animSprite.play('Shoot')
	ball.set_damage(canon_damage)
	spawn_pos.add_child(ball)
	atk_timer.start(3.5)


func _on_AtkTimer_timeout():
	can_shoot = true

func _on_AnimatedSprite_animation_finished():
	animSprite.play('Idle')
