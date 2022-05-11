extends AnimatedSprite
class_name Effect

func _ready():
	self.connect("animation_finished",self,'queue_free')
	self.play('effect')
