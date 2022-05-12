extends Area2D
class_name Ladder

export (NodePath) var platform_collider: NodePath
onready var collider = get_node(platform_collider)
var player: Player = null


func _on_Ladder_body_exited(body):
	if body.name == 'Player':
		print('>>> Ladder: Player exited.')
		if player.can_climbing:
			player.climbing = false
			player.can_climbing = false
			print('>>> Ladder: Player can not climb')
		player = null

func _process(delta):
	if player!=null:
		if player.climbing and Input.is_action_just_pressed("ui_up"):
			collider.set_deferred('disabled',true)
		elif player.can_climbing and Input.is_action_just_pressed('ui_down'):
			collider.set_deferred('disabled', true)
		elif player.can_climbing and player.climbing and Input.is_action_pressed('ui_down'):
			collider.set_deferred('disabled', true)
		else:
			collider.set_deferred('disabled', false)
	else:
		return


func _on_Ladder_body_entered(body):
	if body.name == 'Player':
		player = body
		print('>>> Ladder: Player entered.')
		if !player.can_climbing:
			player.can_climbing = true
			print('>>> Ladder: Player can climb')
