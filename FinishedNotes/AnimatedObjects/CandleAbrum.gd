extends AnimatedSprite




func ready():
	lights_off()


func lights_on():
	for i in get_children():
		i.enabled = true
		self.play('On')
		print('>>> GAMEOBJECT: <CandleAbrum> Lights ON!')


func lights_off():
	for i in get_children():
		i.enabled = false
		self.play('Off')
		print('>>> GAMEOBJECT: <CandleAbrum> Lights OFF!')
