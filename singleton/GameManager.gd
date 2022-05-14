extends Node
var player: Player
var interface: Interface
var inventory: Inventory
var map_holder: Node = null
var current_player_id = null
var weather = null
var played_time = null
var mobile_controller: MobileController = null
var current_map: Node2D
var current_map_name: String
var spawn_positions: Dictionary = {
	'Map': [120,224],
	#'Map':[7146,-707],
	#'Dungeonmap': [-108,-168],
	'Dungeonmap': [3770, -112],
	'DevWorld': [-49,-33]
}

const LOOT: Dictionary ={
	'Gold': preload("res://FinishedNotes/Gold.tscn")
}




func register_player(node: Player):
	player = node 

func register_mobilecontroller(node:MobileController):
	mobile_controller = node
	print('>>> GAMEMANAGER: Mobile-Controller successfully loaded')

func set_mapname(value:String):
	current_map_name = value
	print('>>> GAMEMANAGER: New active mapname: "'+ value +'".')

func register_interface(node: Interface):
	interface = node
	print('>>> GAMEMANAGER: Game-UI successfully loaded.')

func register_inventory(node: Inventory):
	inventory = node
func register_mapholder(node:Node):
	map_holder = node


func changeMap(map_name:String):
	var new_map_instance: PackedScene = load("res://World/Map/"+str(map_name)+".tscn")
	var new_map = new_map_instance.instance()
	if map_holder.get_child_count() != 0:
		map_holder.get_child(0).queue_free()
	map_holder.add_child(new_map)
	current_map = map_holder.get_child(0)
	DataManager.player_data.map = str(map_name)
	new_map = null
	set_player_pos(map_name)
"""
	if map_name == "Map":
		interface.change_parallax(1)
	elif map_name == "Dungeonmap":
		interface.change_parallax(2)
"""

func set_player_pos(map_name):
	player.velocity.y = 0
	player.position =Vector2(spawn_positions[String(map_name)][0],spawn_positions[String(map_name)][1])
	print('Playerspawn found')
