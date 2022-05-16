extends Area2D



export (String, 'Map', 'Map2','DevWorld','Dungeonmap') var teleport_location
var player: Player

func teleport_player():
	pass

func _on_Portal_body_entered(body):
	if !body.name == 'Player':
		return
	else:
		player = body
		GameManager.changeMap(String(teleport_location))
