extends AnimatedSprite


onready var playerDetectionZone = $PlayerDetectionZone

var player


func _process(_delta):
	if playerDetectionZone.player != null:
		if Input.is_action_just_pressed('interact'):
			print('shop interaction')
	else:
		return
