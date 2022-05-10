extends Control

export (Resource) var firesword_item
export (Resource) var practicesword_item


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

onready var fs_icon = firesword_item.icon
onready var ps_icon = practicesword_item.icon 

var player:Player
var weapons = ['PracticeSword','FireSword']
var max_weapons = 2
var next_weapon
var curr_weapon

func _ready():
	next_weapon_btn.disabled = true
	last_weapon_btn.disabled = true
	curr_weapon = weapons[0]

func get_char_stats():
	player = GameManager.player
	damage.text = String(player.weapon.get_damage())
	playername.text = DataManager.player_data.name
	health.text = String(player.max_health)
	stamina.text = String(player.max_stamina)
	amor.text = String(player.max_amor)
	element.text = player.weapon.current_weapon.element_type

func show_weapon_preview():
	player = GameManager.player
	weaponeq_frame.visible = true
	weapon_icon.texture = player.weapon.current_weapon.icon
	if player.weapon.has_firesword:
		next_weapon_btn.disabled = false
		last_weapon_btn.disabled = false
	w_name_label.text = player.weapon.current_weapon.name
	old_damage_label.text = str(player.weapon.damage)
	new_damage_label.text = str(player.weapon.damage)
	weapon_desc.text = str(player.weapon.current_weapon.description)


func _on_WeaponIcon_pressed():
	player = GameManager.player
	if stat_frame.visible:
		stat_frame.visible = false
		show_weapon_preview()

func _on_WeaponBackBtn_pressed():
	player = GameManager.player
	weaponeq_frame.visible = false
	stat_frame.visible = true
