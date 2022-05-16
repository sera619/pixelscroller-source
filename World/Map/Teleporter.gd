class_name Teleporter
extends Area2D


onready var shape = $CollisionShape2D
export (String, "Map", 'Dungeonmap','DevWorld') var teleportlocation ='Dungeonmap'
#export(int, FLAGS, "Fire", "Water", "Earth", "Wind") var spell_elements = 0

var map_name = map_name setget set_name
var map_id: int

func _ready():
	set_name(teleportlocation)
	
func set_name(mapname):
	map_name = String(mapname)
	
func deactivate_shape():
	shape.disabled = true

func activate_shape():
	shape.disabled = false

func Teleport():
	GameManager.interface.fade_level()
	yield(get_tree().create_timer(1),"timeout")
	GameManager.changeMap(String(map_name))
	if GameManager.weather != null:
		GameManager.weather.clear_weather()


func _on_Teleporter_body_entered(body):
	if body.name != 'Player':
		return
	else:
		Teleport()
