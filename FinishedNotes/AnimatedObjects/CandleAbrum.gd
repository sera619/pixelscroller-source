extends AnimatedSprite

onready var light = $MidLight


func ready():
	lights_off()


func lights_on():
	light.enabled = true
	self.play('On')
	#print('>>> GAMEOBJECT: <CandleAbrum> Lights ON!')


func lights_off():
	light.enabled = false
	self.play('Off')
	#print('>>> GAMEOBJECT: <CandleAbrum> Lights OFF!')
