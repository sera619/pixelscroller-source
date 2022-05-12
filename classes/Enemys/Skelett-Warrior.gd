extends KinematicBody2D

onready var hitsound_scene = preload("res://audio/HitSFX.tscn")
onready var swordsound_scene = preload("res://audio/EnemySwordSFX.tscn")
onready var deathsound_scene = preload("res://audio/SkeletDeathSFX.tscn")

onready var stats = $EnemyStats
onready var attack_timer = $MeleeWeapon/AttackTimer
onready var damage_collider = $MeleeWeapon/SkelettSword/CollisionShape2D
onready var health_bar = $Healthbar/Bar
onready var health_plate = $Healthbar

var gravity := 15
var velocity = Vector2(0,0)
export(int) var speed = 32
var look_right: bool = false

var can_attack: bool = true
var is_attacking: bool = false
var can_move: bool = true
var is_alive: bool = true

var see_player: bool = false
var player: Player = null
var start_pos: = position


func _ready():
	$AnimatedSprite.play('Idle')
	stats.connect("health_changed", self, 'update_healthbar')

func update_healthbar():
	health_bar.rect_size.x = 16 * stats.health/ stats.max_health

func showBar():
	if can_see_player() && is_alive:
		health_plate.visible = true
	else:
		health_plate.visible = false

func _process(_delta):
	showBar()
	if !is_alive:
		if !$CollisionShape2D.disabled:
			$CollisionShape2D.disabled = true
			$CollisionShape2D2.disabled = true
			$HitBox/CollisionShape2D.disabled = true
			$MeleeWeapon/SkelettSword/CollisionShape2D.disabled = true
			return
		else:
			return
	move_character()
	if look_right:
		$AnimatedSprite.offset.x = 5
		damage_collider.position.x = 30
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.offset.x = -5
		damage_collider.position.x = -30



func move_character():
	if velocity.x != 0 && can_move :
		$AnimatedSprite.play('Move')
	if velocity.x == 0 && !is_attacking && is_alive:
		$AnimatedSprite.play('Idle')
	if player != null:
		var target = player
		if global_position.x + -32 != target.global_position.x || global_position.x +32 != target.global_position.x && is_attacking:
			if global_position.x -32 > target.global_position.x && !is_attacking:
				velocity.x = -speed
				look_right = false
			elif global_position.x +32 < target.global_position.x && !is_attacking:
				velocity.x = speed
				look_right = true
			else:
				velocity.x = 0
				if can_attack && player.alive:
					attack()
				
	else:
		velocity.x = 0
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

func attack():
	if !can_attack:
		return
	else:
		velocity.x = 0
		is_attacking = true
		can_move = false
		$AnimatedSprite.play('Attack')
		can_attack = false
		attack_timer.start(2.0)
		print('enemy attack')


func take_damage(value):
	stats.set_health(stats.health - value)
	can_move =false
	if stats.health <= 0:
		is_alive = false
		can_move = false
		can_attack = false
		var deathSFX = deathsound_scene.instance()
		get_tree().root.add_child(deathSFX)
		$AnimatedSprite.play('Died')
	else:
		$AnimatedSprite.play('Hurt')

func _on_HitBox_area_entered(area):
	if !area.is_in_group('player_weapon'):
		return
	else:
		var hitSFX = hitsound_scene.instance()
		get_tree().root.add_child(hitSFX)
		take_damage(area.damage)
		

func _on_AttackTimer_timeout():
	can_attack = true


func _on_AnimatedSprite_animation_finished():
	if is_attacking:
		is_attacking = false
		can_move = true
		return
	elif $AnimatedSprite.animation == 'Died':
		$AnimatedSprite.stop()
		$CollisionShape2D.disabled = true
		$CollisionShape2D2.disabled = true
		$HitBox/CollisionShape2D.disabled = true
		$MeleeWeapon/SkelettSword/CollisionShape2D.disabled = true
		z_index = 0
	elif $AnimatedSprite.animation == 'Hurt':
		can_move = true
		return


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == 'Hurt':
		velocity.x = 0
	if $AnimatedSprite.animation == 'Attack' && $AnimatedSprite.frame == 6:
		damage_collider.disabled = false
		var swordSFX = swordsound_scene.instance()
		get_tree().root.add_child(swordSFX)
	elif $AnimatedSprite.animation == 'Attack' && $AnimatedSprite.frame == 7:
		damage_collider.disabled = true


func _on_PlayerDetect_body_entered(body):
	if !body.name == 'Player':
		return
	else:
		health_plate.visible = true
		player = body
		see_player = true

func can_see_player():
	return see_player

func _on_PlayerDetect_body_exited(body):
	if !body.name == 'Player':
		return
	else:
		player = null
		see_player = false
