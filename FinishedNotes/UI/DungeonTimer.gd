extends Control






onready var text_label = $M/V/RichTextLabel



var time_finish = 0
var time_now = 0
var time_left = 0 
var max_time = 0


func set_time(time):
	time_finish = time
	max_time = time_finish + time_now

func _ready():
	set_process(true)

func _process(delta):
	time_now = OS.get_unix_time()
	if max_time > time_now:
		time_left = max_time -time_now
		var display_time = '%02d'% time_left
		text_label.bbcode_text = "[center]"+String(display_time)+"[/center]"
		if !self.visible:
			self.show()
	else:
		if self.visible:
			self.hide()
