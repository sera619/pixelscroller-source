extends Node


var time_start = 0
var time_now = 0

var saved_min = 0
var saved_sec = 0
var saved_hours = 0

func _ready():
	time_start = OS.get_unix_time()
	GameManager.changeMap(String(DataManager.player_data.map))
	set_process(true)
	saved_hours = DataManager.player_data['played_h']
	saved_min = DataManager.player_data['played_min']
	saved_sec = DataManager.player_data['played_sec']

func _process(_delta):
	get_game_time()

func get_game_time():
	time_now = OS.get_unix_time()
	var saved_time_h = saved_hours * 60
	saved_min += saved_time_h
	var saved_time = saved_min * 60
	saved_time += saved_sec 
	var elapsed = time_now - time_start
	elapsed += saved_time
	var minutes = elapsed / 60
	var seconds = elapsed % 60
	var hours = (elapsed / 60) /60
	DataManager.player_data["played_min"] = minutes
	DataManager.player_data["played_sec"] = seconds
	DataManager.player_data["played_h"] = hours
	var time_elasped = "%02d : %02d : %02d" % [DataManager.player_data['played_h'],DataManager.player_data['played_min'],DataManager.player_data['played_sec']]
	GameManager.played_time = time_elasped
