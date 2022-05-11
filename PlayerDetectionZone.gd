extends Area2D

var player = null


func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	if body.name=='Player':
		print('player detected')
		player = body
	else: 
		return

func _on_PlayerDetectionZone_body_exited(body):
	if body.name=='Player':
		player = null
		print('player not detected')
	else:
		return
