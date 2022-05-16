extends Node
class_name MainMenu


onready var animPlayer = $CanvasLayer/AnimationPlayer
onready var fader = $CanvasLayer/Control
onready var error_label = $CanvasLayer/Menu/NewGame/M/V/Label2
onready var newgame_menu = $CanvasLayer/Menu/NewGame
onready var menu = $CanvasLayer/Menu/BG
onready var load_btn = $CanvasLayer/Menu/BG/M/V/LoadBtn
onready var popup = $CanvasLayer/Popup
onready var btnclick_sfx =$BtnClickSFX
onready var delpop = $CanvasLayer/DelPop
onready var delte_text_label = $CanvasLayer/DelPop/BG/M/V/Main
onready var footer_label = $CanvasLayer/Footer/MarginContainer/Label


# Loadpanel
onready var save_slot1 = $CanvasLayer/LoadPanel/BG/M/V/Save1
onready var save_slot2 = $CanvasLayer/LoadPanel/BG/M/V/Save2
onready var save_slot3 = $CanvasLayer/LoadPanel/BG/M/V/Save3


var savegame1 = {}
var savegame2 = {}
var savegame3 = {}

var game_to_load = 0
var game_to_delete = 0
var delete_game_name = ""
var footer_text = "version "+str(Configuration.game_version) + "dev\nPixelscroller 2022 | copyright by s3r43o3"

var nosave_name = '-----'
var nosave_time = '--:--'

func _ready():
	$CanvasLayer/Credits.visible = false
	animPlayer.play("FadeIn")
	footer_label.text = footer_text
	check_loadbtn()
	if get_tree().paused:
		get_tree().paused = false

func _process(_delta):
	if menu.visible:
		newgame_menu.visible = false
		newgame_menu.mouse_filter = Control.MOUSE_FILTER_PASS
		menu.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		newgame_menu.visible = true
		newgame_menu.mouse_filter = Control.MOUSE_FILTER_STOP
		menu.mouse_filter = Control.MOUSE_FILTER_PASS


# check if savegame exists and handle button disable and savegame text
func check_loadbtn():
	var directory = Directory.new()
	var loadbtn1 = $CanvasLayer/LoadPanel/BG/M/V/Save1/GameLoadBtn1
	var delbtn1 = $CanvasLayer/LoadPanel/BG/M/V/Save1/Del1Btn
	var loadbtn2 = $CanvasLayer/LoadPanel/BG/M/V/Save2/GameLoadBtn2
	var delbtn2 = $CanvasLayer/LoadPanel/BG/M/V/Save2/Del2Btn
	var loadbtn3 = $CanvasLayer/LoadPanel/BG/M/V/Save3/GameLoadBtn3
	var delbtn3  = $CanvasLayer/LoadPanel/BG/M/V/Save3/Del3Btn
	if not directory.file_exists("user://save_file1.save"):
		save_slot1.get_node("Label2").text = nosave_name
		save_slot1.get_node("Label3").text = nosave_time
		delbtn1.disabled = true
		loadbtn1.disabled = true
	else:
		delbtn1.disabled = false
		loadbtn1.disabled = false
		var file1 = File.new()
		file1.open("user://save_file1.save", File.READ)
		savegame1 = file1.get_var()
		file1.close()
		save_slot1.get_node("Label2").text = savegame1['name']
		save_slot1.get_node("Label3").text = "%02d:%02d:%02d" % [savegame1['played_h'],savegame1['played_min'],savegame1['played_sec']]
	if not directory.file_exists("user://save_file2.save"):
		save_slot2.get_node("Label2").text = nosave_name
		save_slot2.get_node("Label3").text = nosave_time
		loadbtn2.disabled = true
		delbtn2.disabled = true
	else:
		delbtn2.disabled = false
		loadbtn2.disabled = false
		var file2 = File.new()
		file2.open("user://save_file2.save", File.READ)
		savegame2 = file2.get_var()
		file2.close()
		save_slot2.get_node("Label2").text = savegame2['name']
		save_slot2.get_node("Label3").text = "%02d:%02d:%02d" % [savegame2['played_h'],savegame2['played_min'],savegame2['played_sec']]
	if not directory.file_exists("user://save_file3.save"):
		save_slot3.get_node("Label2").text = nosave_name 
		save_slot3.get_node("Label3").text = nosave_time
		loadbtn3.disabled = true
		delbtn3.disabled = true
	else:
		delbtn3.disabled = false
		loadbtn3.disabled = false
		var file3 = File.new()
		file3.open("user://save_file3.save", File.READ)
		savegame3 = file3.get_var()
		file3.close()
		save_slot3.get_node("Label2").text = savegame3['name']
		save_slot3.get_node("Label3").text = "%02d:%02d:%02d" % [savegame3['played_h'],savegame3['played_min'],savegame3['played_sec']]
	if loadbtn3.disabled && loadbtn1.disabled && loadbtn2.disabled:
		if $CanvasLayer/LoadPanel.visible:
			animPlayer.play("LoadHide")
		load_btn.disabled = true
	else:
		load_btn.disabled = false

func start_new_game():
	DataManager.player_data = DataManager.default_player_data
	DataManager.player_data.name = $CanvasLayer/Menu/NewGame/M/V/LineEdit.text
	var directory = Directory.new()
	if not directory.file_exists(DataManager.SAVE_FILE1):
		game_to_load = 1
		GameManager.current_player_id = 1
		DataManager.save_data(1)
	elif not directory.file_exists(DataManager.SAVE_FILE2) && directory.file_exists(DataManager.SAVE_FILE1):
		game_to_load = 2
		GameManager.current_player_id = 2
		DataManager.save_data(2)
	elif not directory.file_exists(DataManager.SAVE_FILE3) && directory.file_exists(DataManager.SAVE_FILE1) && directory.file_exists(DataManager.SAVE_FILE2):
		game_to_load = 3
		GameManager.current_player_id = 3
		DataManager.save_data(3)
	get_tree().change_scene("res://World/Game.tscn")


func _on_StartBtn_pressed():
	if $CanvasLayer/LoadPanel.visible == true:
		$CanvasLayer/LoadPanel.visible = false
	btnclick_sfx.play()
	animPlayer.play("MenuToNew")

func _on_LoadBtn_pressed():
	btnclick_sfx.play()
	if $CanvasLayer/LoadPanel.visible == false:
		animPlayer.play("LoadShow")
	else:
		animPlayer.play("LoadHide")

func _on_OptionBtn_pressed():
	btnclick_sfx.play()
	print('options pressed')

func _on_ExitBtn_pressed():
	btnclick_sfx.play()
	get_tree().quit(0)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'FadeOut':
		if game_to_load == 0:
			return
		if game_to_load == 1:
			GameManager.current_player_id = 1
			DataManager.load_data(DataManager.SAVE_FILE1)
		if game_to_load == 2:
			GameManager.current_player_id = 2
			DataManager.load_data(DataManager.SAVE_FILE2)
		if game_to_load == 3:
			GameManager.current_player_id = 3
			DataManager.load_data(DataManager.SAVE_FILE3)
		get_tree().change_scene("res://World/Game.tscn")

func _on_LineEdit_text_changed(new_text):
	DataManager.player_data.name = new_text

func _on_NewGameBtn_pressed():
	btnclick_sfx.play()
	if $CanvasLayer/Menu/NewGame/M/V/LineEdit.text == "":
		error_label.text = 'Namensfeld darf nicht leer sein!'
	else:
		var dir = Directory.new()
		if dir.file_exists(DataManager.SAVE_FILE3) && dir.file_exists(DataManager.SAVE_FILE2)&& dir.file_exists(DataManager.SAVE_FILE3):
			popup.show()
		else:
			start_new_game()

func _on_LoadExitBtn_pressed():
	btnclick_sfx.play()
	animPlayer.play_backwards("MenuToNew")



func _on_BackBtn_pressed():
	btnclick_sfx.play()
	popup.hide()
	animPlayer.play_backwards("MenuToNew")

func _on_BtnClickSFX_finished():
	btnclick_sfx.playing = false

func _on_GameLoadBtn1_pressed():
	game_to_load = 1
	btnclick_sfx.play()
	animPlayer.play("FadeOut")

func _on_GameLoadBtn2_pressed():
	game_to_load = 2
	btnclick_sfx.play()
	animPlayer.play("FadeOut")

func _on_GameLoadBtn3_pressed():
	game_to_load = 3
	btnclick_sfx.play()
	animPlayer.play("FadeOut")

"""
Deletion
"""

func delete_game(game_id:int):
	var directory = Directory.new()
	if game_id == 1:
		directory.remove(DataManager.SAVE_FILE1)
		print('>>> DATAMANAGER: SaveGame 1 deleted!')
	elif game_id == 2:
		directory.remove(DataManager.SAVE_FILE2)
		print('>>> DATAMANAGER: SaveGame 2 deleted!')
	elif game_id == 3:
		directory.remove(DataManager.SAVE_FILE3)
		print('>>> DATAMANAGER: SaveGame 3 deleted!')
	else:
		print('>>> DATAMANGER: No Game ID found, cant delete game.')
	game_to_delete = 0

func _on_OkDelBtn_pressed():
	btnclick_sfx.play()
	delete_game(game_to_delete)
	delpop.visible = false
	check_loadbtn()


func _on_CancelDelBtn_pressed():
	btnclick_sfx.play()
	delpop.visible = false

func _on_Del1Btn_pressed():
	btnclick_sfx.play()
	game_to_delete = 1
	delte_text_label.text = "Möchtest du\nSpielstand " + str(game_to_delete)+"\nwirklich löschen?"
	delpop.visible = true


func _on_Del2Btn_pressed():
	btnclick_sfx.play()
	game_to_delete = 2
	delte_text_label.text = "Möchtest du\nSpielstand " + str(game_to_delete)+"\nwirklich löschen?"
	delpop.visible = true

func _on_Del3Btn_pressed():
	btnclick_sfx.play()
	game_to_delete = 3
	delte_text_label.text = "Möchtest du\nSpielstand " + str(game_to_delete)+"\nwirklich löschen?"
	delpop.visible = true


func _on_CreditsBtn_pressed():
	btnclick_sfx.play()
	if !$CanvasLayer/Credits.visible:
		animPlayer.play("ShowCredits")
	elif $CanvasLayer/Credits.visible:
		animPlayer.play("HideCredits")
		
