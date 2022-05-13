extends MapBase



export(String, "20.0","30.0","40.0","10.0") var light_time









func _on_LightTimer_timeout():
	get_tree().call_group('dungeon_light', 'lights_off')

func _on_LightTrigger1_body_entered(body):
	pass # TODO: trigger dark viewport
