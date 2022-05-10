extends Area2D
onready var sound_scene = preload("res://audio/PickupSFX.tscn")

var player: Player


func _on_ChestKey_body_entered(body):
	if body.name != 'Player':
		return
	else:
		player = body
		var sound = sound_scene.instance()
		get_tree().root.add_child(sound)
		player.inventory.set_chest_key(1)
		GameManager.interface.infoBox.set_text('Information!', 'Du hast den Schlüssel für eine Truhe gefunden!')
		self.queue_free()
