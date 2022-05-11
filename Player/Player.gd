class_name Player
extends KinematicBody2D

signal health_changed
signal amor_changed
signal stamina_changed
signal died

export var dash_speed := 5
export var climb_speed:= 90
export var gravity := 20
export var jump_force := 450
export var max_speed := 185
export var regeneration_rate := .5
export var slide_cost: int = 4
export (PackedScene) var spell_scene = preload("res://classes/spells/SwordFireball.tscn")
export var climbing: bool = false
export var can_climbing: bool = false

const UP = Vector2(0,-1)
onready var animSprite = $Body
onready var attack_timer = $Timer
onready var animationPlayer = $AnimationPlayer
onready var weapon = $Weapon/Sword
onready var bodyamor = $Hitbox/BodyAmor
onready var inventory = $Inventory
onready var body_collison = $CollisionShape2D
onready var sfx: AudioStreamPlayer = $SFX
onready var food_sfx = $FoodSFX

onready var max_health : int = DataManager.player_data.max_health
onready var max_amor : int = DataManager.player_data.max_amor
onready var max_stamina: int = DataManager.player_data.max_stamina

var health := max_health setget set_health
var amor := max_amor setget set_amor
var stamina := max_stamina setget set_stamina
var velocity := Vector2.ZERO
var slide_vector := Vector2.ZERO

const AUDIO_EFFECTS: Dictionary = {
	'Hurt': preload("res://audio/audioassets/damage_1_karen.wav"),
	'SwordSlash': preload("res://audio/SwordSlashSFX.tscn")
}
var look_right = true
var can_move = true
var can_attack = true
var can_jump = true
var can_slide = true
var alive = true
var keys: int
var is_moving: bool = false
enum {
	RUN,
	ATK,
	JUMP,
	HURT,
	SLIDE,
	DEAD,
	CLIMB,
	DASH_ATK,
	SWORD_ATK
}
var state
var last_state
var last_x = 0

var interact_obj = null


func _ready():
	state = RUN
	GameManager.register_player(self)
	set_health(max_health)
	set_amor(max_amor)
	set_stamina(max_stamina)


func set_stamina(new_stamina):
	stamina = clamp(new_stamina,0,max_stamina)
	emit_signal('stamina_changed')

func _input(_event):
	if Input.is_action_just_pressed('test'):
		#take_damage(12)
		#weapon.equip_weapon(weapon.second_weapon)
		var spell = spell_scene.instance()
		get_tree().root.add_child(spell)
		spell.global_position = weapon.get_node("Collider").global_position
		if look_right:
			spell.right()
		else:
			spell.left()
	if Input.is_action_just_pressed("interact") && interact_obj != null:
		if interact_obj.name == "Chest":
			interact_obj.interact()
		if interact_obj.name == "LeverPlattform":
			if inventory.keys <= 0:
				GameManager.interface.infoBox.set_text('Information!', 'Du benötigst einen Schlüssel um den Schalter zu benutzen!')
				return
			else:
				inventory.remove_key(1)
				interact_obj.interact()
		else:
			interact_obj.interact()
	if Input.is_action_just_pressed('hotkey1') && inventory.health_potion != 0:
		if health == max_health:
			print('Health is full no need for health potion')
			return
		else:
			set_health(health + 10)
			inventory.set_potion_h(inventory.health_potion - 1)
	if Input.is_action_just_pressed("weapon1") && can_attack:
		weapon.equip_weapon(weapon.weapon)
	if Input.is_action_just_pressed("weapon2") && can_attack:
		weapon.equip_weapon(weapon.fire_sword)

func _process(_delta):
	check_right_sight()

func check_right_sight():
	if climbing:
		animSprite.position.x = 0
		return
	if last_x > 0:
		look_right = true
		animSprite.flip_h = false
		animSprite.position.x = 11
	else:
		look_right = false
		animSprite.flip_h = true
		animSprite.position.x = -11
	
func _physics_process(delta):
	match state:
		RUN:
			move_state(delta)
		ATK:
			atk_state()
		JUMP:
			jump_state()
		HURT:
			hurt_state()
		SLIDE:
			slide_state()
		DEAD:
			dead_state()
		CLIMB:
			climb_state()
		DASH_ATK:
			dash_attack()
		SWORD_ATK:
			sword_attack()

func dash_attack():
	can_attack = false
	velocity.x = 0
	attack_timer.start()
	weapon.set_damage(weapon.damage + weapon.damage)
	if look_right:
		animationPlayer.play("slide_atk_right")
	else:
		animationPlayer.play("slide_atk_left")

func sword_attack():
	can_attack = false
	velocity.x = 0
	attack_timer.start()
	weapon.set_weapon_energie(0)
	var spell = spell_scene.instance()
	spell.position = $Weapon.position
	get_tree().root.add_child(spell)
	if look_right:
		animationPlayer.play("sword_atk_right")
	else:
		animationPlayer.play("sword_atk_left")

func atk_state():
	can_attack = false
	velocity.x = 0
	attack_timer.start()
	if look_right:
		animationPlayer.play("normal_atk_right")
	else:
		animationPlayer.play("normal_atk_left")


func jump_state():
	var last_y = velocity.y
	velocity.y = -jump_force
	state = RUN


func slide_state():
	velocity.y += gravity
	if look_right:
		velocity.x = velocity.x + dash_speed
	else:
		velocity.x = velocity.x - dash_speed
	animationPlayer.play('slide')
	move_and_slide(velocity)
	can_attack = false
	can_slide = false

func climb_state():
	climbing = true


func move_state(delta):
	if !alive:
		return
	if Input.is_action_pressed("move_r"):
		is_moving = true
		velocity.x = max_speed
		last_x = velocity.x
	elif Input.is_action_pressed("move_l"):
		is_moving = true
		velocity.x = -max_speed
		last_x = velocity.x
	else:
		is_moving = false
		velocity.x = 0
	
	if velocity != Vector2.ZERO:
		if velocity.x !=0 and velocity.y == 0 && can_move && is_on_floor():
			animationPlayer.play("run_right")
		elif velocity.y >= 0 && !is_on_floor() && !climbing:
			animationPlayer.play("fall_down")
		elif velocity.y == -500 && !is_on_floor() &&!climbing:
			animationPlayer.play("up2down")
		elif velocity.y <= 0 && !is_on_floor()&&!climbing:
			animationPlayer.play("jump_up")
		elif climbing && velocity.y <=0:
			animationPlayer.play('climbLadder')
		elif climbing && velocity.y >= 0:
			animationPlayer.play('climbLadder')
		elif climbing && velocity.y == 0:
			animationPlayer.play('idleLadder')
	else:
		animationPlayer.play("idle_right")
	velocity.y += gravity
	if Input.is_action_just_pressed('jump') && is_on_floor() && !climbing:
		state = JUMP
	if can_climbing && !climbing:
		if Input.is_action_pressed('ui_up') or Input.is_action_pressed('ui_down'):
			climbing = true
	#print(velocity)
	if Input.is_action_just_pressed("attack")  && is_on_floor() && can_attack:
		state = ATK
	if Input.is_action_just_pressed("dash_attack") && is_on_floor() && can_attack:
		state = DASH_ATK
	if Input.is_action_just_pressed('sword_attack') && is_on_floor() && can_attack && weapon.weapon_energie == weapon.max_weapon_energie:
		state = SWORD_ATK
	if Input.is_action_just_pressed("slide") && is_on_floor() && can_slide && is_moving:
		if stamina >= slide_cost:
			set_stamina(stamina-slide_cost)
			state = SLIDE
		else:
			pass
	if Input.is_action_pressed("crouch") && is_on_floor() && !climbing:
		animationPlayer.play("crouch")
		return
	if climbing:
		velocity.y = 0
		if Input.is_action_pressed("ui_up"):
			velocity.y = -climb_speed
		elif Input.is_action_pressed('ui_down'):
			velocity.y = climb_speed
		else:
			velocity.y = 0
			animationPlayer.play("idleLadder")
	move(delta)

func move(_delta):
	velocity = move_and_slide(velocity,UP)

func sword_spell():
	var spell = spell_scene.instance()
	$Weapon.add_child(spell)
	if look_right:
		spell.right()
	else:
		spell.left()


func _on_Timer_timeout():
	can_attack = true

func swordFX():
	var swordSFX = AUDIO_EFFECTS.SwordSlash.instance()
	get_tree().root.add_child(swordSFX)

func take_damage(amount: int) -> void:
	sfx.stream = AUDIO_EFFECTS.Hurt
	sfx.play()
	$Camera2D.shake_intensity = 1.6
	if amount > max_amor:
		set_amor(0)
		amount -= max_amor
	if amor > 0:
		set_amor(amor-amount)
		state = HURT
		return
	set_health(health-amount)
	if health > 0:
		state = HURT
	else:
		state = DEAD

func revive():
	set_health(max_health)
	set_amor(max_amor)
	set_stamina(max_stamina)
	alive = true
	can_attack = true
	can_move = true
	can_jump = true
	can_slide = true
	state = RUN

func set_health(new_health: int) -> void:
	health = clamp(new_health, 0 , max_health)
	print('health is now: '+ str(health))
	emit_signal("health_changed")


func set_amor(new_amor: int) -> void:
	amor = clamp(new_amor, 0 , max_amor)
	emit_signal("amor_changed")
	
func atk_animation_finished():
	can_move = true
	weapon.reset_damage()
	state = RUN

func slide_animation_finished():
	can_move = true
	can_attack = true
	can_slide = true
	velocity.x = 0
	state = RUN

func hurt_state():
	velocity.x = 0 
	can_attack = false
	can_move = false
	animationPlayer.play("hurt")


func dead_state():
	if alive:
		animationPlayer.play('die')
	else:
		animationPlayer.stop()
		can_move = false
		can_attack = false
		can_slide = false
		can_jump = false
		velocity = Vector2.ZERO
	
	
func hurt_animation_finished():
	can_attack = true
	can_move = true
	state = RUN


func _on_Hitbox_area_entered(area):
	if area.is_in_group('enemy_weapon'):
		take_damage(area.damage)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'die':
		animationPlayer.stop()
		alive = false
		emit_signal('died')
	elif anim_name == 'slide_atk_left' || anim_name == 'slide_atk_right':
		weapon.reset_damage()
	else:
		pass


func _on_InteractionZone_body_entered(body): 
	if body.is_in_group('interact'):
		interact_obj = body
	else:
		return


func _on_InteractionZone_body_exited(body):
	if body.is_in_group('interact'):
		interact_obj = null


func _on_InteractionZone_area_entered(area):
	if area.is_in_group('interact'):
		interact_obj = area
	else:
		return

func _on_InteractionZone_area_exited(area):
	if area.is_in_group('interact'):
		interact_obj = null
	else:
		return



func _on_SFX_finished():
	sfx.stop()




func _on_AnimationPlayer_animation_changed(old_name, new_name):
	if old_name == 'fall_down':
		print('fall down end')
		food_sfx.play()
