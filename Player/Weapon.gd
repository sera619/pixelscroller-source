class_name Weapon
extends Area2D

signal dmg_changed(new_damage)

signal weapon_changed
signal weapon_energie_changed
signal max_energie_changed
signal full_energie

var current_weapon


var damage = damage setget set_damage
var reset_dmg = reset_dmg setget set_damage
var max_weapon_energie = max_weapon_energie setget set_max_weapon_energie
var weapon_energie= weapon_energie setget set_weapon_energie

var arsenal = []

func _ready():
	arsenal = DataManager.player_data.arsenal
#	if DataManager.player_data.current_weapon == "":
#		equip_weapon(arsenal[0])
#	else:
	equip_weapon(DataManager.player_data.current_weapon)
	if GameManager.mobile_controller != null:
		self.connect('full_energie', GameManager.mobile_controller,'show_z_btn')



func set_weapon_energie(value):
	weapon_energie = clamp(value, 0, max_weapon_energie)
	emit_signal('weapon_energie_changed')
	if weapon_energie == 0:
		if GameManager.mobile_controller != null:
			GameManager.mobile_controller.hide_z_btn()

func set_max_weapon_energie(value):
	max_weapon_energie = int(value)
	emit_signal("max_energie_changed")

func set_damage(new_damage):
	damage = new_damage
	emit_signal('dmg_changed', new_damage)
	emit_signal("weapon_changed")

func reset_damage():
	set_damage(reset_dmg)
	emit_signal('dmg_changed',reset_dmg)
	emit_signal("weapon_changed")

func get_damage():
	return damage

func equip_weapon(new_weapon):
	var sword = load("res://classes/items/"+String(new_weapon)+".tres")
	current_weapon = sword
	reset_dmg = current_weapon.weapon_damage
	DataManager.player_data.current_weapon = str(new_weapon)
	set_damage(current_weapon.weapon_damage)
	emit_signal("weapon_changed")
	if current_weapon.weapon_energie !=0:
		set_max_weapon_energie(int(current_weapon.weapon_energie))
		set_weapon_energie(0)
	else:
		GameManager.interface.weaponEnergiePlate.visible = false

func loot_weapon(weapon_name:String):
	if weapon_name in arsenal:
		print('>>> PlayerWeapon: Weapon "'+weapon_name+'" is already in Arsenal. Ignore Loot.')
		return
	arsenal.append(String(weapon_name))
	DataManager.player_data.arsenal = arsenal
	print('>>> PlayerWeapon: New Weapon "'+weapon_name+'" added to arsenal')
	print('>>> PlayerWeapon: New Arsenal: ',arsenal)
	equip_weapon(weapon_name)

func _on_Sword_area_entered(area):
	if !area.is_in_group('enemy_hitbox'):
		return
	if max_weapon_energie != null:
		if weapon_energie > max_weapon_energie:
			weapon_energie = max_weapon_energie
		else:
			set_weapon_energie(weapon_energie + 1)
			if weapon_energie == max_weapon_energie:
				emit_signal('full_energie')
			
