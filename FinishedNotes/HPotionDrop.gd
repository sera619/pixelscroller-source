extends Area2D

var player: Player
onready var sound_scene = preload("res://audio/PickupSFX.tscn")

func _on_HPotionDrop_body_entered(body):
	if !body.name == 'Player':
		return
	else:
		player = body
		player.inventory.add_healthPotion(1)
		var pickupSFX = sound_scene.instance()
		get_tree().root.add_child(pickupSFX)
		self.call_deferred('queue_free')
