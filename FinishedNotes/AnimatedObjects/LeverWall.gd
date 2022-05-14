extends Area2D

onready var audio = $AudioStreamPlayer
onready var animSprite = $Sprite

export(bool) var is_on: bool = false



func interact():
	if !is_on:
		lever_on()
	else:
		lever_off()

func lever_on():
	is_on = true
	audio.play()
	animSprite.play('On')
	get_tree().call_group('map','set_timer',25.0)

func lever_off():
	is_on = false
	audio.play()
	animSprite.play('Off')


func _on_Sprite_animation_finished():
	if animSprite.animation == 'On':
		get_tree().call_group('dungeon_light','lights_on')
	elif animSprite.animation == 'Off':
		get_tree().call_group('dungeon_light', 'lights_off')
