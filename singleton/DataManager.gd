extends Node

var default_player_data ={
	'name': '',
	'level':1,
	'max_health': 10,
	'max_stamina': 10,
	'max_amor': 3,
	'map':'Map',
	'gold': 10,
	'keys': 0,
	'chest_key':0,
	'weapon':'PracticeSword',
	'bodyamor':'PracticeAmor',
	'health_potions': 1,
	'mana_potions':1,
	'played_min':0,
	'played_sec':0
}

var player_data = {}
enum PROFIL {
	SLOT1,
	SLOT2,
	SLOT3
}


var current_save_file = null



const SAVE_FILE1 = "user://save_file1.save"
const SAVE_FILE2 = "user://save_file2.save"
const SAVE_FILE3 = "user://save_file3.save"



func save_data(id: int):
	var file = File.new()
	file.open("user://save_file"+String(id)+".save", File.WRITE)
	file.store_var(player_data)
	file.close()
	print('>>> DATAMANAGER: Playerdata successfully saved!')
	

func load_data(savefile):
	current_save_file = savefile
	var file = File.new()
	file.open(savefile, File.READ)
	player_data = file.get_var()
	file.close()
	print(player_data)
