extends KinematicBody2D


onready var health_plate = $HealthPlate
onready var health_bar = $HealthPlate/HealthBar
onready var stats = $EnemyStats
onready var animSprite = $Body
onready var weapon = $Weapon/Breath
onready var weapon_collider = weapon.get_node("CollisionShape2D")
onready var atk_timer = $Weapon/Timer
onready var hitbox = $Hitbox/CollisionShape2D

export var move_speed: int = 64

enum {
	VANISH,
	IDLE,
	MOVE,
	ATTACK,
	HURT,
	DEAD,
	APPEAR
}

var state
var velocity = Vector2.ZERO
var can_attack = true
var is_alive = true
var look_right = false
var see_player: bool = false
var first_seen: bool = true


var player: Player = null




func _ready():
	state = VANISH
	update_healthbar()
	weapon.set_damage(stats.max_damage)

func _process(delta):
	turn_sprite()

func can_see_player():
	return see_player

func _physics_process(delta):
	match state:
		VANISH:
			if self.visible:
				self.visible = false
			return
		IDLE:
			weapon_collider.disabled = true
			velocity.x = 0
			animSprite.play('Idle')
			if can_see_player():
				if player.global_position.x > self.global_position.x:
					look_right = true
				else:
					look_right = false
				state = MOVE
			else:
				state= IDLE
		MOVE:
			animSprite.play('Idle')
			var target: Player
			if player != null && player.alive:
				target = player
				if self.global_position.x+ 128 < target.global_position.x || self.global_position.x -128 > target.global_position.x:
					if self.global_position.x + 128 < target.global_position.x:
						velocity.x = move_speed
						look_right = true
					elif self.global_position.x -128 > target.global_position.x:
						velocity.x = -move_speed
						look_right = false
					else:
						velocity.x = 0
				else:
					velocity.x = 0
					if can_attack:
						state = ATTACK
					else:
						state = IDLE
			else:
				state = IDLE
		ATTACK:
			turn_sprite()
			if can_attack:
				can_attack = false
				animSprite.play('Breath')
		HURT:
			turn_sprite()
			velocity.x = 0
			can_attack = false
			animSprite.play('Hurt')
		DEAD:
			if is_alive:
				velocity.x = 0
				animSprite.play('Death')
			else:
				return
		APPEAR:
			animSprite.position.y = -72
			self.visible = true
			animSprite.play('Appear')
	turn_sprite()
	move_and_slide(velocity)

func turn_sprite():
	if look_right:
		animSprite.flip_h = true
		weapon.position.x = 54
	else:
		animSprite.flip_h = false
		weapon.position.x = -54

func take_damage(value):
	velocity.x = 0
	stats.set_health(stats.health -value)
	if stats.health > 0:
		state = HURT
	else:
		state = DEAD


func update_healthbar():
	health_bar.rect_size.x = 60 * stats.health / stats.max_health
	

func _on_EnemyStats_health_changed():
	update_healthbar()


func _on_Body_frame_changed():
	if animSprite.animation != 'Breath':
		weapon_collider.disabled = true
	if animSprite.animation == 'Breath' && animSprite.frame == 6:
		weapon_collider.disabled = false
	if animSprite.animation == 'Breath' && animSprite.frame == 9:
		weapon_collider.disabled = true

func _on_Body_animation_finished():
	if animSprite.animation == 'Appear':
		animSprite.position.y = -80
		state = IDLE
	elif animSprite.animation == 'Breath':
		atk_timer.start(4.5)
		state = MOVE
	elif animSprite.animation == 'Death':
		is_alive = false
		weapon_collider.disabled = true
		$CollisionShape2D.disabled = true
		$CollisionShape2D2.disabled = true
		health_plate.visible = false
		animSprite.visible = false
		hitbox.disabled = true
	elif animSprite.animation == 'Hurt':
		atk_timer.start(2.5)
		state = MOVE

func _on_Timer_timeout():
	can_attack = true

func _on_PlayerDetect_body_entered(body):
	if !body.name =='Player':
		return
	else:
		player = body
		health_plate.visible = true
		see_player = true
		if first_seen:
			first_seen = false
			state = APPEAR
		else:
			state = MOVE



func _on_PlayerDetect_body_exited(body):
	if !body.name == 'Player':
		return
	else:
		health_plate.visible = false
		see_player =false
		player = null
		state = IDLE



func _on_Hitbox_area_entered(area):
	if area.is_in_group('player_weapon'):
		take_damage(area.damage)
