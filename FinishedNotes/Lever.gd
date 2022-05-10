extends Area2D

signal lever_on
signal lever_off

export var is_on : bool = false
onready var animSprite = $AnimatedSprite
onready var light_container = get_parent().get_node('LightContainer')
var lights

func _ready():
	lights = light_container.get_children()


func interact():
	switch_lever()


func switch_lever():
	if !is_on:
		animSprite.play('on')
		is_on = true
		emit_signal("lever_on")
	else:
		animSprite.play('off')
		is_on = false
		emit_signal("lever_off")



func _on_AnimatedSprite_animation_finished():
	if is_on:
		for light in lights:
			light.light_on()
	else:
		for light in lights:
			light.light_off()
