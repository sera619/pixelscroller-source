extends AnimatedSprite






func fire_on():
	self.play('start')
	
	
func fire_off():
	self.play('end')
	
func _on_FlameEffect_animation_finished():
	if !self.animation == 'start':
		return
	self.play('loop')
