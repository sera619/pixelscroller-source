extends Control

export (NodePath) var key_android_path
export (NodePath) var key_win_path
export (NodePath) var btn_sfx_path

onready var keymap_android = get_node(key_android_path)
onready var keymap_win = get_node(key_win_path)
onready var btn_sfx = get_node(btn_sfx_path)

var keymap_frame

func _ready():
	pass

func _on_KeyMapBtn_pressed():
	btn_sfx.play()
	if OS.get_name() == 'Android':
		keymap_frame = keymap_android
	else:
		keymap_frame = keymap_win
	if !keymap_frame.visible:
		self.hide()
		keymap_frame.visible = true


func _on_BugBtn_pressed():
	btn_sfx.play()
	OS.shell_open("https://github.com/sera619/pixelscroller-source/issues/1")

func _on_BackBtn_pressed():
	btn_sfx.play()
	if get_tree().paused:
		get_tree().paused = false
	self.hide()


func _on_CloseBtn_pressed():
	btn_sfx.play()
	if get_tree().paused:
		get_tree().paused = false
	keymap_frame.hide()
