extends Area2D

export (Resource) var amor_to_drop
onready var animPlayer: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $Sprite
onready var soundsfx_scene = preload('res://audio/PickupSFX.tscn')

var player: Player = null


func _ready():
	animPlayer.play("loop")



func _on_AmorDrop_body_entered(body):
	if !body.name == 'Player':
		return
	else:
		player = body
		var sfx = soundsfx_scene.instance()
		get_tree().root.add_child(sfx)
		player.bodyamor.loot_amor(String(amor_to_drop.name))
		self.call_deferred('queue_free')
