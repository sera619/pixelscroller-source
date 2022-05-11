extends Area2D


onready var hit_effect = preload("res://Effects/HitEffect.tscn")


func _on_Hitbox_area_entered(area):
	if !area.is_in_group('enemy_weapon'):
		return
	else:
		var effect = hit_effect.instance()
		self.add_child(effect)
