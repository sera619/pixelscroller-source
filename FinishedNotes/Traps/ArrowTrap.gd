extends Node2D


export(float, 3.0, 20.0) var cooldown_time: float = 5.0
export(int) var trap_damage: int = 4
export(PackedScene) var arrow_scene: PackedScene


onready var animSprite = $Sprite
onready var timer = $Cooldown
onready var spawn = $BulletSpawn

var can_shoot: bool = true
export (bool) var automatic_shoot

func _ready():
	if !automatic_shoot:
		animSprite.play('Idle')
	else:
		shoot()


func _process(_delta):
	shoot()




func shoot():
	if can_shoot:
		timer.start(cooldown_time)
		can_shoot = false
		animSprite.play('Shoot')
	else:
		return

func shoot_arrow():
	var arrow = arrow_scene.instance()
	spawn.add_child(arrow)
	arrow.set_damage(trap_damage)
	arrow.fly_left()

func _on_Cooldown_timeout():
	can_shoot = true
	

func _on_Sprite_animation_finished():
	if animSprite.animation == 'Shoot':
		animSprite.play('Idle')


func _on_Sprite_frame_changed():
	if animSprite.animation == 'Shoot' && animSprite.frame == 3:
		shoot_arrow()

