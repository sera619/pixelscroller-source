extends Control


export (NodePath) var exitBtn
export (NodePath) var macro_menu_path
export (NodePath) var stat_panel_path
export (NodePath) var help_path

onready var macro_menu = get_node(macro_menu_path)
onready var stat_panel = get_node(stat_panel_path)
onready var help_panel = get_node(help_path)
onready var mobile_help_panel = get_parent().get_node("Help-Android")
onready var pause_sound = preload("res://audio/PauseSFX.tscn")
onready var unpause_sound = preload("res://audio/UnpauseSFX.tscn")
onready var btnSFX = get_parent().get_node('ButtonSFX')
onready var time_label = $NinePatchRect/MarginContainer/VBoxContainer/Time

var playerdata = DataManager.player_data

func _process(_delta):
	if Input.is_action_just_pressed('menu'):
		game_pause()



func game_pause():
		time_label.text = String(GameManager.played_time)
		if get_tree().paused:
			get_tree().paused = false
			var unpauseSFX = unpause_sound.instance()
			get_tree().root.add_child(unpauseSFX)
			self.hide()
		else:
			get_tree().paused = true
			var pauseSFX = pause_sound.instance()
			get_tree().root.add_child(pauseSFX)
			self.show()


func _on_BackBtn_button_down():
	self.hide()
	get_tree().paused = false

func _on_ExitBtn_button_down():
	btnSFX.play()
	DataManager.save_data(GameManager.current_player_id)
	get_parent().fade_level()
	yield(get_tree().create_timer(1.0),"timeout")
	get_tree().change_scene("res://World/MainMenu.tscn")


func _on_HomeBtn_pressed():
	game_pause()

func _on_StatsBtn_pressed():
	btnSFX.play()
	if stat_panel.visible:
		stat_panel.visible = false
	else:
		stat_panel.get_char_stats()
		stat_panel.visible = true

func _on_HelpBtn_pressed():
	btnSFX.play()
	if OS.get_name() == 'Android':
		help_panel = mobile_help_panel
	if help_panel.visible:
		help_panel.visible = false
	else:
		help_panel.visible = true


func _on_MenuBtn_pressed():
	btnSFX.play()
	game_pause()


func _on_CloseBtn_pressed():
	btnSFX.play()
	help_panel.visible = false


func _on_DevMap_pressed():
	btnSFX.play()
	game_pause()
	GameManager.changeMap("DevWorld")
	


func _on_Save_pressed():
	btnSFX.play()
	get_parent().infoBox.set_text('Information!', 'Das Spiel wurde erfolgreich gespeichert!')
	DataManager.save_data(int(GameManager.current_player_id))


func _on_AndroidCloseBtn_pressed():
	btnSFX.play()
	mobile_help_panel.visible = false


func _on_OkStatsBtn_pressed():
	btnSFX.play()
	stat_panel.visible = false

