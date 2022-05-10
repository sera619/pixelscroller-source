extends Area2D

export(int) var gold_amount = 5
onready var sound_scene = preload("res://audio/PickupSFX.tscn")
var player: Player
	

func _on_Gold_body_entered(body):
	if body.name != 'Player':
		return
	else:
		player = body
		player.inventory.set_gold(player.inventory.current_gold+gold_amount)
		var pickupSFX = sound_scene.instance()
		get_tree().root.add_child(pickupSFX)
		self.call_deferred('queue_free')
