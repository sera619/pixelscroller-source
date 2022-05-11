class_name Weapon
extends Area2D

signal dmg_changed(new_damage)
signal firesword_looted
signal frostsword_looted

export(Resource) var weapon
export(Resource) var fire_sword


export (bool) var has_firesword:bool = false
export (bool) var has_frostsword:bool = false

signal weapon_changed
signal weapon_energie_changed
signal max_energie_changed
var current_weapon


var damage = damage setget set_damage
var reset_dmg = reset_dmg setget set_damage
var max_weapon_energie = max_weapon_energie setget set_max_weapon_energie
var weapon_energie= weapon_energie setget set_weapon_energie

func _ready():
	if weapon != null:
		equip_weapon(weapon)
	max_weapon_energie = 0


func set_weapon_energie(value):
	weapon_energie = clamp(value, 0, max_weapon_energie)
	emit_signal('weapon_energie_changed')

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
	current_weapon = new_weapon
	reset_dmg = current_weapon.weapon_damage
	set_damage(current_weapon.weapon_damage)
	emit_signal("weapon_changed")
	if current_weapon.weapon_energie !=0:
		set_max_weapon_energie(int(current_weapon.weapon_energie))
		set_weapon_energie(0)
	else:
		GameManager.interface.weaponEnergiePlate.visible = false
	

func loot_weapon(looted_weapon):
	if looted_weapon == 'FireSword':
		has_firesword = true
		emit_signal("firesword_looted")
	elif looted_weapon == 'FrostSword':
		has_frostsword = true
		emit_signal("frostsword_looted")
	else:
		pass

func _on_Sword_area_entered(area):
	if !area.is_in_group('enemy_hitbox'):
		return
	if max_weapon_energie != 0:
		set_weapon_energie(weapon_energie + 1)
