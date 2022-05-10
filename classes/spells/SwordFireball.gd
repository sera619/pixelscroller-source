extends Area2D


export(int) var spell_damage: int = 5
var damage = spell_damage setget set_damage


func _ready():
	set_damage(spell_damage)


func set_damage(new_damage):
	damage = new_damage

func left():
	$AnimationPlayer.play('left')

func right():
	$AnimationPlayer.play("right")
