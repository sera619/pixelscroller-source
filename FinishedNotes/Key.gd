extends Area2D
onready var sound_scene = preload("res://audio/PickupSFX.tscn")



func _on_Key_body_entered(body):
	if body.name == 'Player':
		GameManager.inventory.add_key(1)
		var pickupSFX = sound_scene.instance()
		get_tree().root.add_child(pickupSFX)
		self.call_deferred('queue_free')
	else:
		return
