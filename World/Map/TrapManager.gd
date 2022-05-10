extends Node2D

onready var boltTrapScene = preload("res://FinishedNotes/BoltTrap.tscn")
onready var timer = $Timer
onready var spawn_points = $Node2D.get_children()


func _ready():
	timer.start(5)



func spawn_trap():
	for s in spawn_points:
		var trap = boltTrapScene.instance()
		s.add_child(trap)
		trap.hit_left()
	timer.start(5)




func _on_Timer_timeout():
	spawn_trap()
