extends Area2D

onready var sound_scene = preload("res://audio/PickupSFX.tscn")
var player: Player

func _on_HealthUp_body_entered(body):
	if !body.name == 'Player':
		return
	else:
		player = body
		var pickupSFX = sound_scene.instance()
		get_tree().root.add_child(pickupSFX)
		DataManager.player_data.max_health += 5
		player.max_health += 5
		player.set_health(player.max_health)
		GameManager.interface.infoBox.set_text('Information!', "Glückwunsch!\nDeine maximale Lebensenergie wurde um\n5\nerhöt!")
		self.call_deferred('queue_free')
