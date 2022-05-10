class_name Inventory

extends Node


signal keys_changed
signal pots_changed
signal gold_changed
const MAX_GOLD = 999
export var keys: int = 1
export var chest_key: int = 0
export var max_mana_potion: int = 3
export var max_health_potion: int = 3
const MAX_STACK: int  = 9
var health_potion = max_health_potion setget set_potion_h
var mana_potion = max_mana_potion setget set_potion_m
var current_gold = MAX_GOLD setget set_gold
 

func _ready():
	GameManager.register_inventory(self)
	set_key(int(DataManager.player_data.keys))
	set_potion_h(int(DataManager.player_data.health_potions))
	set_potion_m(int(DataManager.player_data.mana_potions))
	set_gold(int(DataManager.player_data.gold))
	set_chest_key(int(DataManager.player_data.chest_key))

# KEY functions
func add_key(value):
	if keys == MAX_STACK:
		print('Keys are on maximum')
		return
	keys += value
	DataManager.player_data.keys = int(keys)
	GameManager.interface.infoBox.set_text('Information!', 'Du hast einen Schlüssel erhalten!')
	emit_signal("keys_changed")

func remove_key(value):
	if keys == 0:
		print('No more Keys available')
		return
	keys -= value
	DataManager.player_data.keys = int(keys)
	GameManager.interface.infoBox.set_text('Information!', 'Ein Schlüssel wurde benutzt!')
	emit_signal("keys_changed")

func set_key(new_keys):
	keys = new_keys
	emit_signal("keys_changed")


func set_gold(new_value):
	current_gold = new_value
	DataManager.player_data.gold = int(current_gold)
	emit_signal("gold_changed")

func set_chest_key(new_keys):
	chest_key = new_keys
	DataManager.player_data.chest_key = int(new_keys)
	emit_signal("keys_changed")


func add_manaPotion(value):
	mana_potion += value
	DataManager.player_data.mana_potions = int(mana_potion)
	emit_signal("pots_changed")
	
func set_potion_m(value):
	mana_potion = value
	emit_signal('pots_changed')
	
	
func remove_manaPotion(value):
	mana_potion -= value
	DataManager.player_data.mana_potions = int(mana_potion)
	emit_signal("pots_changed")
	
func add_healthPotion(value):
	health_potion += value
	DataManager.player_data.health_potions = int(health_potion)
	emit_signal("pots_changed")
	
func remove_healthPotion(value):
	health_potion -= value
	DataManager.player_data.health_potions = int(health_potion)
	emit_signal("pots_changed")
	
func set_potion_h(value):
	health_potion = value
	emit_signal('pots_changed')
