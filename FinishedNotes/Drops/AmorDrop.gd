extends Area2D

export (Resource) var amor_to_drop = preload("res://classes/items/Amor/Rostiger Panzer.tres")
onready var animPlayer: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $Sprite
onready var soundsfx_scene = preload('res://audio/PickupSFX.tscn')
onready var loot_popup_scene = preload("res://FinishedNotes/UI/LootPopup.tscn")

var player: Player = null

func _ready():
	if amor_to_drop != null:
		sprite.texture = amor_to_drop.icon
	animPlayer.play("loop")



func _on_AmorDrop_body_entered(body):
	if !body.name == 'Player':
		return
	else:
		player = body
		var sfx = soundsfx_scene.instance()
		get_tree().root.add_child(sfx)
		player.bodyamor.loot_amor(String(amor_to_drop.name))
		var loot_popup = loot_popup_scene.instance()
		GameManager.interface.add_child(loot_popup)
		loot_popup.set_loot_text(String(amor_to_drop.item_type),String(amor_to_drop.name),amor_to_drop.icon)
		self.call_deferred('queue_free')
