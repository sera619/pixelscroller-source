class_name MapBase
extends Node2D

export (String, 'Map', 'Mapdungeon','DevWorld') var map_name: String
#var enemy_scene = load("res://Enemy-Skeletton-M.tscn")
var map: String = map_name setget set_mapName


func _ready():
	set_mapName(self.name)
	GameManager.current_map = self

	
func set_mapName(value: String):
	map = value
	GameManager.set_mapname(map)
	
