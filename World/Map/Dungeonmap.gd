extends MapBase



export(String, "20.0","30.0","40.0","10.0") var light_time
onready var light_timer = $LightTimer
onready var anim_player = $AnimationPlayer
onready var enemyspawn1 = $SpawnContainer/EnemySpawns
onready var enemyspawn2 = $SpawnContainer/EnemySpawns2
var map_is_dark: bool = false

var player: Player

func _ready():
	call_deferred('spawn_enemys')
	call_deferred('spawn_enemys2')
	GameManager.interface.infoBox.set_text('LEVEL 2', 'Finde die Orbs die sich in Kisten befinden!\nAchte auf das Licht!')


func spawn_enemys():
	for p in enemyspawn1.get_children():
		var enemy = GameManager.ENEMYS.SkeletonW.instance()
		p.add_child(enemy)

func spawn_enemys2():
	for p in enemyspawn2.get_children():
		var enemy = GameManager.ENEMYS.GhostMage.instance()
		p.add_child(enemy)


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


func _on_DeahtZone_body_entered(body):
	if !body.name == 'Player':
		return
	else:
		player = body
		player.take_damage(99999999)
