extends Control


onready var slow_debuff_frame = $M/H/SlowDebuff
onready var icon = $M/H/SlowDebuff/Icon
onready var slow_timer =$M/H/SlowDebuff/SlowTimer
onready var animPlayer = $AnimationPlayer


var is_active: bool = false


func start_slow(slow_time:float):
	self.show()
	slow_debuff_frame.show()
	animPlayer.play("slow_debuff")
	slow_timer.start(slow_time)

func hide_debuff():
	if slow_debuff_frame.visible:
		slow_debuff_frame.hide()


func _on_SlowTimer_timeout():
	animPlayer.stop()
	hide_debuff()
	self.hide()
