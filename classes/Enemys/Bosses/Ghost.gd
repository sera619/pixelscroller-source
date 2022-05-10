extends KinematicBody2D


export(int) var max_speed = 96
export(PackedScene) var spell_scene: PackedScene
export(PackedScene) var reward_scene: PackedScene

onready var hitsound_scene = preload("res://audio/HitSFX.tscn")
onready var melee_weapon = $Weapon/Melee
onready var melee_collider = $Weapon/Melee/CollisionShape2D
onready var spell_spawn = $Weapon/SpellSpawns
onready var atk_timer = $Weapon/AtkTimer

onready var health_bar = $Plate/V/HealthBar/Bar
onready var energie_bar = $Plate/V/ShieldBar/Bar
onready var health_plate = $Plate
onready var sprite = $AnimatedSprite
onready var stats = $Stats
enum {
	IDLE,
	HURT,
	DEAD,
	ATK,
	CAST,
	GHOST_IDLE,
	INVINCIBLE,
	CHASE
}

var state = INVINCIBLE

var velocity = Vector2.ZERO
var start_position = Vector2.ZERO
var is_attacking: bool = false
var can_move: bool = true
var look_right: bool = true
var see_player: bool = false
var can_attack: bool = true
var is_alive: bool = true
var player_rewarded: bool = false
var player: Player = null



func _ready():
	start_position = global_position
	stats.connect('health_changed', self, 'update_healthbar')
	stats.connect('shield_changed', self, 'update_energiebar')
	stats.set_shield(0)

func _process(delta):
	if !is_alive:
		return
	sprite_flip()
	if look_right:
		sprite.flip_h = false
		melee_collider.position.x = 27
		melee_collider.rotation_degrees = 55
	else:
		sprite.flip_h = true
		melee_collider.position.x = -27
		melee_collider.rotation_degrees = -55


func sprite_flip():
	if player == null:
		return
	else:
		var target = player
		if target.position.x < position.x:
			look_right = false
		else:
			look_right = true


func _physics_process(delta):
	match state:
		INVINCIBLE:
			invis_state()
		IDLE:
			idle_state()
		HURT:
			hurt_state()
		GHOST_IDLE:
			ghost_idle_state()
		ATK:
			attack_state()
		CHASE:
			chase_state()
		DEAD:
			dead_state()
		CAST:
			cast_state()
	move_and_slide(velocity)

func chase_state():
	if !is_alive:
		return
	if player != null && player.alive:
		if stats.shield == stats.max_shield:
			state = CAST
		if player.position.x + 40 < position.x:
			velocity.x = - max_speed
		elif player.position.x - 40 > position.x:
			velocity.x = max_speed
		else:
			if can_attack && stats.shield != stats.max_shield:
				state = ATK
			elif can_attack && stats.shield == stats.max_shield:
				state = CAST
			else:
				state = IDLE
	else:
		state = IDLE

	
	
func invis_state():
	if player != null:
		sprite.visible = true
		sprite.play('Appear')
	else:
		sprite.stop()
		sprite.visible = false

func hurt_state():
	velocity = Vector2.ZERO
	can_attack = false
	sprite.play('Hurt')
	

func dead_state():
	velocity= Vector2.ZERO
	can_attack = false
	can_move = false
	if !player_rewarded:
		reward_player()
	if !is_alive:
		return
	sprite.play('Death')

func idle_state():
	if !sprite.visible:
		sprite.visible = true
	velocity = Vector2.ZERO
	sprite.play('Idle')
	if player != null:
		state = CHASE

func ghost_idle_state():
	velocity = Vector2.ZERO
	sprite.play('SummonIdle')
	if can_see_player():
		if player.position.x > position.x -4 || player.position.x < position.x +4:
			sprite.visible = false
			global_position.y = player.global_position.y -12 
			if look_right:
				position.x = player.position.x + 186
			else:
				position.x = player.position.x - 186
			state = IDLE

func attack_state():
	if !is_attacking:
		can_attack = false
		atk_timer.start(3.5)
		velocity = Vector2.ZERO
		is_attacking = true
		sprite.play('Attacking')


func reward_player():
	var reward = reward_scene.instance()
	get_parent().add_child(reward)
	reward.position = self.position
	if look_right:
		reward.position.x -= 64
	else:
		reward.position.x += 64
	player_rewarded = true

func cast_state():
	velocity.x = 0
	if player != null && player.alive:
		if !can_attack && stats.shield != stats.max_shield:
			return
		else:
			stats.set_shield(0)
			can_attack = false
			atk_timer.start(3.5)
			position.x = player.global_position.x
			position.y = player.global_position.y - 156
			velocity = Vector2.ZERO
			yield(get_tree().create_timer(2.5),"timeout")
			for spawn in spell_spawn.get_children():
				var spell = spell_scene.instance()
				spell.connect('player_hitted',self, 'set_energie')
				spawn.add_child(spell)
			state = GHOST_IDLE
		
func set_energie():
	var half: int = stats.max_shield / 2
	stats.set_shield(half)

func _on_AnimatedSprite_animation_finished():
	if sprite.animation == 'Appear':
		state = GHOST_IDLE
	if sprite.animation == 'Attacking':
		is_attacking = false
		state = IDLE
	if sprite.animation == 'Hurt':
		can_attack = true
		state = IDLE
	if sprite.animation == 'Death':
		is_alive = false
		can_attack = false
		can_move = false
		health_plate.visible = false

# HEALTH BAR

func update_healthbar():
	health_bar.rect_size.x = 48 * stats.health / stats.max_health

func update_energiebar():
	energie_bar.rect_size.x = 48 * stats.shield / stats.max_shield


func can_see_player():
	return see_player


func _on_PlayerDetect_body_entered(body):
	if !body.name == 'Player':
		return
	else:
		player = body
		health_plate.visible = true
		see_player = true

func _on_PlayerDetect_body_exited(body):
	if !body.name == 'Player':
		return
	else:
		player = null
		health_plate.visible = false
		see_player = false


func _on_AtkTimer_timeout():
	can_attack = true


func _on_AnimatedSprite_frame_changed():
	if sprite.animation== 'Attacking':
		if sprite.frame == 2 || sprite.frame == 9:
			melee_collider.disabled = false
		elif sprite.frame == 3 || sprite.frame == 10:
			melee_collider.disabled = true


func _on_Melee_area_entered(area):
	if area.is_in_group('player_hitbox'):
		stats.set_shield(stats.shield + 1)

func take_damage(value):
	stats.set_health(stats.health - value)
	var hitSFX = hitsound_scene.instance()
	get_tree().root.add_child(hitSFX)
	if stats.health <= stats.max_health:
		state = HURT
	if stats.health >= 0:
		state = DEAD

func _on_HitBox_area_entered(area):
	if area.is_in_group('player_weapon'):
		take_damage(area.damage)
