extends Node
class_name BodyAmor


export (Resource) var practice_amor
signal bodyamor_changed
signal defense_changed

onready var player: Player = get_parent().get_parent()

var current_bodyamor = null
var defense = defense setget set_defense
var defense_arsenal = []

var normal_jumpforce = 450



func _ready():
	defense_arsenal = DataManager.player_data.defense_arsenal
	equip_bodyamor(DataManager.player_data.current_bodyamor)

func get_defense():
	return int(current_bodyamor.amor_defense)


func equip_bodyamor(new_bodyamor):
	var new_amor = load('res://classes/items/Amor/'+String(new_bodyamor)+'.tres')
	current_bodyamor = new_amor
	set_defense(int(current_bodyamor.amor_defense))
	DataManager.player_data.current_bodyamor =new_bodyamor
	if new_bodyamor == 'Federleichter Umhang':
		boost_jump(true)
	else:
		boost_jump(false)
	emit_signal("bodyamor_changed")

func loot_amor(amor_name:String):
	if amor_name in defense_arsenal:
		print('>>> PlayerAmor: Bodyamor already exists in defense arsenal. Skip loot.')
		return
	defense_arsenal.append(String(amor_name))
	DataManager.player_data.defense_arsenal = defense_arsenal
	print('>>> PlayerAmor: New Bodyamor '+String(amor_name)+' added to arsenal.')
	equip_bodyamor(amor_name)


func set_defense(new_defense):
	defense = int(new_defense)
	emit_signal("defense_changed")

func boost_jump(active:bool):
	if active:
		player.set_jumpforce(player.jump_force +50)
		print('>>> AMOR: Jump-Boost is active!')
	else:
		player.set_jumpforce(normal_jumpforce)
		print('>>> AMOR: Jump-Boost deactivated!')
