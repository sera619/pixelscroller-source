extends Popup

onready var text_label = $BG/M/V/Main
onready var sfx = $ButtonSFX
onready var header_label = $BG/M/V/Header
onready var item_icon = $BG/M/V/TextureRect
var header_base = "Neue %s erhalten!"
var main_base = "[center]Du hast [color=red]'%s'[/color] gefunden.\n"

var main_text = "Test Text"


func set_loot_text(item_type, itemname:String,drop_text:String, new_icon):
	var full_text = main_base % itemname
	var full_header = header_base % item_type
	main_text = drop_text
	text_label.bbcode_text = full_text + "\n[center][color=green]" + main_text
	header_label.text = full_header
	item_icon.texture = new_icon
	self.popup_centered()



func _on_OkBtn_pressed():
	get_tree().paused = false
	sfx.play()
	yield(sfx,"finished")
	self.call_deferred('queue_free')
