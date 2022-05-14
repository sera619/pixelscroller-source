extends Control


onready var slow_debuff_frame = $M/H/SlowDebuff
onready var icon = $M/H/SlowDebuff/Icon
onready var tween = $Tween
onready var slow_timer =$M/H/SlowDebuff/SlowTimer
onready var animPlayer = $AnimationPlayer


var is_active: bool = false


func start_slow(slow_time:float):
	self.show()
	animPlayer.play("slow_debuff")
	var seconds = slow_time
	var milliseconds = slow_time / 60
	var time_text = "%0d:%0d" % [seconds,milliseconds]
	slow_debuff_frame.get_node("Time").text = String(time_text)
	slow_timer.start(slow_time)

func hide_debuff():
	if slow_debuff_frame.visible:
		slow_debuff_frame.visible = false


func _on_SlowTimer_timeout():
	animPlayer.stop()
	hide_debuff()
	self.hide()
