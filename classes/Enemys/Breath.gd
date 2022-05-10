extends Area2D



var damage: int = 0


func set_damage(value):
	damage = value

func _on_EnemyStats_damage_changed():
	var stats = get_parent().get_parent().stats
	set_damage(stats.damage)
