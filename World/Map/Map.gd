extends MapBase

onready var interface: Interface = GameManager.interface
onready var enemy_container = $SpawnContainer/EnemySpawns
onready var enemy2_container =$SpawnContainer/EnemySpawns2
onready var boss_spawn = $SpawnContainer/BossSpawn
onready var map_audio = $AudioStreamPlayer
export(PackedScene) var enemy_scene
export(PackedScene) var enemy2_scene
export(PackedScene) var boss_scene
var infobox: InfoBox


func _ready():
	GameManager.map_audio = map_audio
	infobox = interface.get_node('InfoBox')
	if infobox != null:
		infobox.set_text('Willkommen bei <keksdose>', 'In diesem ersten Level kannst du dich mit der Steuerung vertraut machen.\nKlicke auf das "?" um die Tastaturbelegung zu sehen.')
	if enemy_container != null:
		call_deferred('spawn_enemys')
		call_deferred('spawn_enemys2')
		call_deferred('spawn_boss')
		
func spawn_boss():
	var boss = boss_scene.instance()
	boss_spawn.add_child(boss)

func spawn_enemys():
	for point in enemy_container.get_children():
		var enemy = enemy_scene.instance()
		point.add_child(enemy)

func spawn_enemys2():
	for p in enemy2_container.get_children():
		var enemy2 = enemy2_scene.instance()
		p.add_child(enemy2)


func _on_DeathZone_body_entered(body):
	if body.name == 'Player':
		var player:Player = body
		if !player.alive:
			return
		else:
			player.take_damage(999999)


func _on_FinishZone_body_entered(body):
	if !body.name == 'Player':
		return
	else:
		GameManager.interface.infoBox.set_text('Information!','GESCHAFFT!\nDu hast das Tutorial abgeschlossen!\nBenutze das Tor um in das nächste Level zu gelangen.')
		$FinishZone.queue_free()
