extends AnimatedSprite


onready var light = $Light2D
export (bool) var lights_on = false


func _ready():
	self.stop()
	self.visible = false

func _process(_delta):
	if lights_on:
		self.visible = true
		self.play()
		light.enabled = true
	else:
		self.stop()
		self.visible = false
		light.enabled = false
		


func light_on():
	lights_on = true

func light_off():
	lights_on = false
