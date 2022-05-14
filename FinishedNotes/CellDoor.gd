extends Area2D

onready var animSprite = $AnimatedSprite
onready var sfx = $CellSound
onready var teleporter = $Teleporter
export (String, 'Map', 'Dungeonmap') var teleporter_destination


signal open
signal close
export var is_open: bool = false

func _ready():
	teleporter.teleportlocation = teleporter_destination


func interact():
	if !is_open:
		animSprite.play('open')
		is_open = true
		emit_signal('open')
		sfx.play()
	else:
		animSprite.play('close')
		is_open = false
		emit_signal('close')
		sfx.play()


func _on_AnimatedSprite_animation_finished():
	if is_open:
		get_node('Teleporter').activate_shape()
	else:
		get_node("Teleporter").deactivate_shape()
