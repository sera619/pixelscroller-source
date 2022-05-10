class_name InfoBox

extends Control
onready var title = $BG/M/V/HeadLabel
onready var text = $BG/M/V/TextLabel
onready var timer = $Timer

var text_dic = []

func set_text(titletxt, maintxt):
	if !self.visible:
		title.text = str(titletxt)
		text.text = str(maintxt)
		self.visible = true
		timer.start(5.0)



func _on_Timer_timeout():
	if text_dic != []:
		set_text(String(text_dic[0]),String(text_dic[1]))
		text_dic.remove(0)
		text_dic.remove(1)
	else:
		self.visible = false
