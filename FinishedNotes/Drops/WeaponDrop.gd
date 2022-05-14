extends Area2D


export (Resource) var weapon_to_drop = preload("res://classes/items/Feuer-Schwert.tres")

onready var loot_popup_scene = preload("res://FinishedNotes/UI/LootPopup.tscn")
onready var audio_scene = preload("res://audio/PickupSFX.tscn")
onready var sprite = $Sprite
onready var weapon_icon = weapon_to_drop.icon
onready var anim_player = $AnimationPlayer
var player:Player

func _ready():
	if weapon_to_drop != null:
		sprite.texture = weapon_icon
	anim_player.play('loop')

func _on_WeaponDrop_body_entered(body):
	if body.name != 'Player':
		return
	else:
		player = body
		var audio = audio_scene.instance()
		get_tree().root.add_child(audio)
		player.weapon.loot_weapon(String(weapon_to_drop.name))
		var loot_popup = loot_popup_scene.instance()
		GameManager.interface.add_child(loot_popup)
		loot_popup.set_loot_text(String(weapon_to_drop.item_type),String(weapon_to_drop.name), String(weapon_to_drop.drop_text) , weapon_icon)
		self.call_deferred('queue_free')
