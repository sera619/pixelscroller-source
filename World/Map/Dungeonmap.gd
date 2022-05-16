extends MapBase



export(String, "20.0","30.0","40.0","10.0") var light_time
onready var light_timer = $LightTimer
onready var anim_player = $AnimationPlayer

var map_is_dark: bool = false


func set_timer(time):
	light_timer.wait_time = time
	GameManager.interface.dungeon_timer.set_time(time)
	light_timer.start()
	print('>>> MAP: Lights on for '+String(time)+'!')

func _on_LightTimer_timeout():
	get_tree().call_group('dungeon_light', 'lights_off')
	print('>>> MAP: Lights off!')

func _on_LightTrigger1_body_entered(body):
	if !map_is_dark:
		map_is_dark = true
		anim_player.play("HideCastle")
		get_tree().call_group('camera', 'lights_off')
		get_tree().call_group('dungeon_light', 'lights_on')
		#GameManager.interface.dungeon_timer.set_time(20.0)
		#light_timer.start(20.0)
		print('>>> MAP: Lights on for '+String(20.0)+'!')
	else:
		map_is_dark = false
		anim_player.play_backwards("HideCastle")
		get_tree().call_group('camera', 'lights_on')
