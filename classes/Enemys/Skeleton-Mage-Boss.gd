extends KinematicBody2D

export(PackedScene) var spell_scene
export(PackedScene) var loot_scene

onready var hitsound_scene: PackedScene = preload("res://audio/HitSFX.tscn")
onready var hit_effect_scene: PackedScene = preload("res://Effects/HitEffect.tscn")
onready var death_sfx_scene: PackedScene = preload("res://audio/SkeletDeathSFX.tscn")
onready var stats = $EnemyStats
onready var attack_timer = $Weapon/Timer

onready var plate = $Plate
onready var health_bar: TextureRect = $Plate/HealthPlate/HealthBar
onready var energie_bar: TextureRect = $Plate/EngeriePlate/EnergieBar
onready var sprite = $AnimatedSprite
onready var spawn_container = $Weapon/Spawns
onready var normal_spawn = $Weapon/NormalSpawn
onready var energie_timer= $EnergieTimer

var gravity := 15
var velocity = Vector2(0,0)
export(int) var speed =  48
var flee_range = 196


var can_attack: bool = true
var is_attacking: bool = false
var can_move: bool = true
var is_alive: bool = true
var look_right: bool = true

var see_player: bool = false
var player: Player = null
var rng = RandomNumberGenerator.new()

var reward_dropped: bool = false



func _ready():
	sprite.play('Idle')
	stats.connect("shield_changed", self, 'update_energiebar')
	stats.connect("health_changed", self, 'update_healthbar')
	stats.set_shield(0)
	rng.randomize()


func _process(delta):
	if look_right:
		sprite.flip_h = false
		sprite.offset.x = 4
		for i in spawn_container.get_children():
			i.position.x = 32
	else:
		sprite.flip_h = true
		sprite.offset.x = -4
		for i in spawn_container.get_children():
			i.position.x = -32

func _physics_process(_delta):
	show_bar()
	if is_alive:
		move_character()



func show_bar():
	if can_see_player() && is_alive:
		plate.visible = true
	else:
		plate.visible = false

func take_damage(value):
	var hit_effect = hit_effect_scene.instance()
	self.add_child(hit_effect)
	stats.set_health(stats.health - value)
	if stats.health <= 0:
		var death_sfx =death_sfx_scene.instance()
		self.add_child(death_sfx)
		is_alive = false
		can_move = false
		can_attack = false
		sprite.play('Die')
	else:
		can_move = false
		sprite.play('Hurt')
		

func move_character():
	if velocity.x != 0 && !is_attacking && can_move:
		sprite.play('Move')
	if velocity.x == 0 && !is_attacking && is_alive:
		sprite.play('Idle')
	if player != null:
		var target = player
		if global_position.x + flee_range != target.global_position.x || global_position.x -flee_range != target.global_position.x && !is_attacking:
			if global_position.x + flee_range < target.global_position.x && !is_attacking:
				velocity.x = speed
				look_right = true
			elif global_position.x - flee_range > target.global_position.x && !is_attacking:
				velocity.x = -speed
				look_right = false
			else:
				velocity.x = 0
				if can_attack && player.alive:
					if target.global_position.x< global_position.x:
						look_right = false
					else:
						look_right = true
					attack()
		else:
			velocity.x = 0
			if can_attack && player.alive:
				attack()
			
	else:
		velocity.x = 0
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

func reward_player():
	loot_drop()


func loot_drop():
	var loot = loot_scene.instance()
	add_child(loot)
	if look_right:
		loot.global_position = self.global_position
		loot.global_position.x -= 32
	else:
		loot.global_position = self.global_position
		loot.global_position.x += 32
		


func update_healthbar():
	health_bar.rect_size.x = 26 * stats.health / stats.max_health

func update_energiebar():
	energie_bar.rect_size.x =  26 * stats.shield / stats.max_shield


func attack():
	is_attacking = true
	velocity.x = 0
	can_move = false
	can_attack = false
	attack_timer.start(3.5)
	sprite.play('Attack')
	
func can_see_player():
	return see_player

func _on_PlayerDetect_body_entered(body):
	if !body.name == 'Player':
		return
	else:
		player = body
		see_player = true

func _on_PlayerDetect_body_exited(body):
	if !body.name == 'Player':
		return
	else:
		player = null
		see_player = false

func _on_HitBox_area_entered(area):
	if !area.is_in_group('player_weapon'):
		return
	else:
		var hitSFX = hitsound_scene.instance()
		get_tree().root.add_child(hitSFX)
		take_damage(area.damage)

func _on_AnimatedSprite_animation_finished():
	if sprite.animation == 'Attack':
		is_attacking = false
		can_move = true
		return
	elif sprite.animation == 'Die':
		z_index = -1
		if !reward_dropped:
			$CollisionShape2D.disabled =true
			$CollisionShape2D2.disabled = true
			reward_dropped = true
			reward_player()
	elif sprite.animation == 'Hurt':
		can_move = true
		can_attack = true

func cast_spell():
	var spell = spell_scene.instance()
	normal_spawn.add_child(spell)
	if look_right:
		spell.fly_right()
	else:
		spell.fly_left()

func cast_spell_ultimate():
	for spawn in spawn_container.get_children():
		var spell = spell_scene.instance()
		spawn.add_child(spell)
		spell.position = spawn.global_position
		if look_right:
			spell.fly_right()
		else:
			spell.fly_left()
	stats.set_shield(0)

func _on_AnimatedSprite_frame_changed():
	if sprite.animation == 'Hurt':
		velocity.x = 0
	if sprite.animation == 'Attack' && sprite.frame == 10 && stats.shield == stats.max_shield:
		cast_spell_ultimate()
		return
	elif sprite.animation == 'Attack' && sprite.frame == 10 && stats.shield != stats.max_shield:
		cast_spell()

func _on_Timer_timeout():
	can_attack = true


func _on_EnergieTimer_timeout():
	if stats.shield < stats.max_shield:
		stats.set_shield(stats.shield + 1)
	else:
		stats.shield = stats.max_shield
		return
