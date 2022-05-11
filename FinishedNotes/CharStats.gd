extends Control

onready var playername = $Bg/M/V/StatContainer/namevalue
onready var health = $Bg/M/V/StatContainer/healthvalue
onready var stamina = $Bg/M/V/StatContainer/StaminaValue
onready var damage = $Bg/M/V/StatContainer/DamageValue
onready var element = $Bg/M/V/StatContainer/ElementValue
onready var amor = $Bg/M/V/StatContainer/amorvalue
onready var stat_frame = $Bg

# Weapon Equip vars
onready var weaponeq_frame = $EQWeapon 
onready var old_damage_label =$EQWeapon/M/V/GC/OldDamage
onready var new_damage_label = $EQWeapon/M/V/GC/NewDamage
onready var w_name_label = $EQWeapon/M/V/WeaponName
onready var weapon_icon = $EQWeapon/M/V/H/WeaponIcon
onready var next_weapon_btn = $EQWeapon/M/V/H/NextBtn
onready var last_weapon_btn = $EQWeapon/M/V/H/BeforeBtn
onready var weapon_desc = $EQWeapon/M/V/Desc

onready var default_weapon = preload("res://classes/items/Holz-Schwert.tres")

var player:Player

var max_weapons = 2
var next_weapon
var curr_weapon = 0
var next_weapon_name = ""


func _ready():
	player = GameManager.player
	next_weapon_btn.disabled = true
	last_weapon_btn.disabled = true
	max_weapons = DataManager.player_data.arsenal.size()
	for weapon in max_weapons:
		print(DataManager.player_data.arsenal[weapon-1])

func show_weapon_preview():
	curr_weapon = 0
	weaponeq_frame.visible = true
	max_weapons = DataManager.player_data.arsenal.size()
	print(max_weapons)
	if max_weapons > 1:
		next_weapon_btn.disabled = false
		last_weapon_btn.disabled = false
	w_name_label.text = default_weapon.name
	old_damage_label.text = str(player.weapon.current_weapon.weapon_damage)
	new_damage_label.text = str(default_weapon.weapon_damage)
	weapon_icon.texture = default_weapon.icon
	weapon_desc.text = str(default_weapon.description)


func get_char_stats():
	player = GameManager.player
	damage.text = String(player.weapon.current_weapon.weapon_damage)
	playername.text = DataManager.player_data.name
	health.text = String(player.max_health)
	stamina.text = String(player.max_stamina)
	amor.text = String(player.max_amor)
	element.text = player.weapon.current_weapon.element_type


func _on_WeaponIcon_pressed():
	get_node('../ButtonSFX').play()
	if stat_frame.visible:
		stat_frame.visible = false
		show_weapon_preview()

func _on_WeaponBackBtn_pressed():
	get_node('../ButtonSFX').play()
	weaponeq_frame.visible = false
	get_char_stats()
	stat_frame.visible = true


func _on_BeforeBtn_pressed():
	get_node('../ButtonSFX').play()
	curr_weapon += 1
	if curr_weapon == max_weapons:
		curr_weapon = 0
	next_weapon_name = String(DataManager.player_data.arsenal[curr_weapon])
	print(next_weapon_name)
	next_weapon = load("res://classes/items/"+next_weapon_name+".tres")
	update_weapon_eq()

func update_weapon_eq():
	weapon_icon.texture = next_weapon.icon
	w_name_label.text = next_weapon.name
	if player.weapon.get_damage() < next_weapon.weapon_damage:
		new_damage_label.set("custom_colors/font_color", Color(0.239216, 0.909804, 0.117647))
	elif player.weapon.get_damage() > next_weapon.weapon_damage:
		new_damage_label.set("custom_colors/font_color",Color(0.87207, 0.054504, 0.11678))
	else:
		new_damage_label.set("custom_colors/font_color",Color(0.871021, 0.89393, 0.895508))
	old_damage_label.text = str(player.weapon.get_damage())
	new_damage_label.text = str(next_weapon.weapon_damage)
	weapon_desc.text = str(next_weapon.description)


func _on_NextBtn_pressed():
	get_node('../ButtonSFX').play()
	if curr_weapon == 0:
		curr_weapon = max_weapons
	curr_weapon -= 1
	next_weapon_name = String(DataManager.player_data.arsenal[int(curr_weapon)])
	print(next_weapon_name)
	next_weapon = load("res://classes/items/"+next_weapon_name+".tres")
	update_weapon_eq()

func _on_WeaponEquipBtn_pressed():
	get_node('../ButtonSFX').play()
	player.weapon.equip_weapon(next_weapon_name)
	update_weapon_eq()
	get_char_stats()
	
