extends StaticBody2D

export var is_open: bool = false
export(PackedScene) var reward_drop

onready var animPlayer = $AnimatedSprite

var player: Player

func interact():
	player = GameManager.player
	if !is_open:
		if player.inventory.chest_key != 0:
			player.inventory.set_chest_key(0)
			animPlayer.play('open')
			reward_player()
		else:
			GameManager.interface.infoBox.set_text('Information','Du brauchst einen Schlüssel für diese Kiste!')


func reward_player():
	var loot = reward_drop.instance()
	self.add_child(loot)
	if position.x < player.position.x:
		loot.global_position = self.global_position
		loot.global_position.x -= 48
	else:
		loot.global_position = self.global_position
		loot.global_position.x += 48
	pass


func _on_AnimatedSprite_animation_finished():
	is_open = true
