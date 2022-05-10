extends Node

export (int) var stamina_reg := 2
export (int) var amor_reg := 2
onready var regTimer = $RegTimer
onready var player = get_parent()




func _process(_delta):
	reg_stamina()
	reg_amor()


func reg_stamina():
	if !player.alive:
		return
	elif player.stamina < player.max_stamina && regTimer.is_stopped():
		regTimer.start(1)
		print('regtimer started')




func reg_amor():
	if !player.alive:
		return
	if player.amor < player.max_amor && regTimer.is_stopped():
		regTimer.start(1)
		print('regtimer started')




func _on_RegTimer_timeout():
	if player.stamina != player.max_stamina:
		player.set_stamina(player.stamina + 1)
		print('new stamina: '+ str(player.stamina))
		return
	elif player.amor != player.max_amor:
		player.set_amor(player.amor +1)
		print('new amor: ' + str(player.amor))
		return
	elif player.alive:
		regTimer.stop()

