extends Area2D

signal lever_on
signal lever_off

export var is_on : bool = false
export(NodePath) var plattform_path: NodePath
onready var animSprite = $AnimatedSprite
var plattform: Node2D


func _ready():
	plattform = get_node(plattform_path)

func interact():
	if !is_on:
		switch_lever()
	else:
		return


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
	if animSprite.animation == 'on':
		plattform.move()
