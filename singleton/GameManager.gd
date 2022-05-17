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
var map_audio = null


const spawn_positions: Dictionary = {
	'Map': [120,224],
	#'Map':[7146,-707],
	'Dungeonmap': [-108,-168],
	#'Dungeonmap': [3770, -112],
	'DevWorld': [-49,-33],
	'Map2':[0,10]
}

const ENEMYS: Dictionary = {
	'SkeletonW': preload("res://classes/Enemys/Skelett-Warrior.tscn"),
	'SkeletonM': preload("res://classes/Enemys/Skeleton-Mage.tscn"),
	'SkeletonBoss': preload("res://classes/Enemys/Skeleton-Mage-Boss.tscn"),
	'GhostMage': preload("res://classes/Enemys/Ghost-Mage.tscn")
}

const LOOT: Dictionary ={
	'Gold': preload("res://FinishedNotes/Gold.tscn"),
	'HealthDrop': preload("res://FinishedNotes/HPotionDrop.tscn")
}
const AUDIO: Dictionary = {
	'PlayerDead': preload('res://audio/DeadSFX.tscn')
}
const MAPS: Dictionary = {
	'Map': preload('res://World/Map/Map.tscn'),
	'Map2': preload('res://World/Map/Map2.tscn'),
	'Dungeonmap': preload('res://World/Map/Dungeonmap.tscn'),
	'DevWorld': preload('res://World/Map/DevWorld.tscn')
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

func register_mapaudio(node):
	map_audio = node
	print('>>> GAMEMANAGER: Map Audio successfully loaded.')

func register_inventory(node: Inventory):
	inventory = node
func register_mapholder(node:Node):
	map_holder = node


func changeMap(map_name:String):
	map_audio = null
	var new_map = MAPS[map_name].instance()
	if map_holder.get_child_count() != 0:
		map_holder.get_child(0).queue_free()
	map_holder.call_deferred('add_child',new_map)
	current_map = new_map
	DataManager.player_data.map = str(map_name)
	new_map = null
	set_player_pos(map_name)


func set_player_pos(map_name):
	player.velocity.y = 0
	player.position =Vector2(spawn_positions[String(map_name)][0],spawn_positions[String(map_name)][1])
	print('>>> GAMEMANAGER: Player-Position is set to: X: '+String(spawn_positions[String(map_name)][0])+' | Y: '+String(spawn_positions[String(map_name)][1]))
