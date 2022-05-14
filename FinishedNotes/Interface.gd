class_name Interface
extends CanvasLayer

onready var healthBar = $StatBar/VBoxContainer/HealthBar
onready var amorBar = $StatBar/VBoxContainer/AmorBar
onready var staminaBar = $StatBar/VBoxContainer/ManaBar
onready var keyLabel = $Inv/H/BG/M/H/Keys/StackTxt
onready var player: Player = get_parent().get_node("Player")
onready var inventory = get_parent().get_node('Player/Inventory')
onready var infoBox = get_node('InfoBox')
onready var mana_pot_label = $Inv/H/BG/M/H/MPotion/StackTxt
onready var heal_pot_label = $Inv/H/BG/M/H/HPotion/StackTxt
onready var heal_pot_icon = $Inv/H/BG/M/H/HPotion/HPotIocn
onready var mana_pot_icon = $Inv/H/BG/M/H/MPotion/MPotIcon
onready var animPlayer = $AnimationPlayer
onready var death_screen =$DeathScreen
onready var player_weapon = player.get_node("Weapon/Sword")
onready var player_amor = player.get_node('Hitbox/BodyAmor')
onready var gold_label =$Inv/Gold/GoldAmount
onready var buttonSFX = $ButtonSFX
onready var mobile_controlls = preload("res://FinishedNotes/UI/MobileControlls.tscn")
onready var chest_key = $Inv/ChestKey
onready var weaponLabel = $CharStats/Bg/M/V/Equip/WeaponStats/V/WeaponName
onready var weaponElementLabel = $CharStats/Bg/M/V/Equip/WeaponStats/V/WeaponElement
onready var weaponEnergiePlate = $WeaponEnergie
onready var weapon_energie_bar = $WeaponEnergie/WeaponEnergiePlate/WEnergieBar
onready var debuff_bar = $DebuffBar
onready var dungeon_timer = $DungeonTimer

onready var game_menu = $GameMenu

onready var amorIcon = $CharStats/Bg/M/V/Equip/AmorIcon
onready var amorLabel = $CharStats/Bg/M/V/Equip/AmorStats/V/AmorName
onready var amorElementLabel = $CharStats/Bg/M/V/Equip/AmorStats/V/AmorElement
onready var mobile_stick = $MobileStick


var mobile_controller = null

const BGS ={
	1: preload("res://World/ParallaxMap.tscn"),
	2: preload("res://World/ParallaxDungeon.tscn")
	}


func _ready():
	if OS.get_name() == 'Android':
		mobile_controller = mobile_controlls.instance()
		mobile_stick.add_child(mobile_controller)
	death_screen.mouse_filter = Control.MOUSE_FILTER_PASS 
	animPlayer.play("start")
	GameManager.register_mapholder(get_parent().get_node('MapHolder'))
	GameManager.register_interface(self)
	player.connect('health_changed',self,'update_health')
	player.connect('stamina_changed', self, 'update_stamina')
	player.connect('amor_changed', self, 'update_amor')
	player.connect('died', self, 'show_deathscreen')
	inventory.connect('keys_changed', self, 'update_keys' )
	inventory.connect('gold_changed', self, 'update_gold')
	inventory.connect('pots_changed', self, 'update_potions')
	player_weapon.connect('weapon_changed', self, 'update_weapon')
	player_weapon.connect('weapon_energie_changed', self, 'update_weapon_bar')
	player_amor.connect('bodyamor_changed', self, 'update_bodyamor')

func show_deathscreen():
	death_screen.visible =true
	death_screen.mouse_filter = Control.MOUSE_FILTER_STOP
	animPlayer.play("fadeIn_deathscreen")

func show_weapon_bar():
	if player_weapon.current_weapon.weapon_energie == 0:
		weaponEnergiePlate.visible = false
		return
	else:
		weaponEnergiePlate.visible = true

func update_gold():
	gold_label.text = String(inventory.current_gold)

func fade_level():
	animPlayer.play("level_fadeIn")

func update_health():
	healthBar.rect_size.x = 118 * player.health/player.max_health

func update_amor():
	amorBar.rect_size.x = 126 * player.amor /player.max_amor

func update_stamina():
	staminaBar.rect_size.x = 109 * player.stamina/player.max_stamina

func update_keys():
	keyLabel.text = str(inventory.keys)
	if inventory.chest_key != 0:
		chest_key.visible = true
	else:
		chest_key.visible = false
	

func update_potions():
	heal_pot_label.text = str(inventory.health_potion)
	mana_pot_label.text = str(inventory.mana_potion)
	if inventory.health_potion == 0:
		heal_pot_icon.set('modulate', Color(1, 1, 1, 0.235294))
	else:
		heal_pot_icon.set('modulate', Color(1,1,1,1))
	if inventory.mana_potion == 0:
		mana_pot_icon.set('modulate', Color(1, 1, 1, 0.235294))
	else:
		mana_pot_icon.set('modulate', Color(1,1,1,1))


func update_weapon():
	weaponLabel.text = player_weapon.current_weapon.name
	weaponElementLabel.text = player_weapon.current_weapon.element_type
	$CharStats/Bg/M/V/Equip/WeaponIcon.texture_normal = player_weapon.current_weapon.icon
	$CharStats/Bg/M/V/Equip/WeaponIcon.texture_pressed = player_weapon.current_weapon.icon
	$CharStats/Bg/M/V/Equip/WeaponIcon.texture_hover = player_weapon.current_weapon.icon
	show_weapon_bar()

func update_bodyamor():
	amorLabel.text = player_amor.current_bodyamor.name
	amorElementLabel.text = str(player_amor.current_bodyamor.amor_defense)
	amorIcon.texture_normal = player_amor.current_bodyamor.icon
	amorIcon.texture_hover = player_amor.current_bodyamor.icon
	amorIcon.texture_pressed = player_amor.current_bodyamor.icon
	

func update_weapon_bar():
	weapon_energie_bar.rect_size.x = 65 * player_weapon.weapon_energie / player_weapon.max_weapon_energie


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'fadeOut_deathscreen':
		death_screen.visible = false
	else:
		pass

func _on_LoadBtn_pressed():
	buttonSFX.play()
	animPlayer.play("fadeOut_deathscreen")
	player.revive()
	GameManager.set_player_pos(GameManager.current_map_name)




func _on_ExitBtn_pressed():
	buttonSFX.play()
	animPlayer.play("fadeOut_deathscreen")
	yield(get_tree().create_timer(1.0),"timeout")
	get_tree().change_scene("res://World/MainMenu.tscn")
	


func _on_HPotIocn_pressed():
	player.use_healthpotion()


func _on_MPotIcon_pressed():
	player.use_manapotion()
