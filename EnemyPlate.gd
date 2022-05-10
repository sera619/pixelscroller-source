extends Control

onready var healthBar = $Health/Bar


func _ready():
	get_parent().connect("health_changed", self, 'update_health')


func update_health():
	healthBar.rect_size.x = 36 * get_parent().health/get_parent().max_health 
