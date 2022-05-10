extends KinematicBody2D


var target
var boost_speed:= 260.0
var move_speed := 160.0

var max_speed := move_speed
var velocity := Vector2(0,0)
var last_x := 0.0
var drag_factor := 0.1


func _process(delta):
	if last_x < 0.0:
		$Body.flip_h = false
	else:
		$Body.flip_h = true
	var direction :=Input.get_vector("move_l",'move_r',"ui_up",'ui_down')
	if Input.is_action_just_pressed("attack"):
		max_speed = boost_speed
		get_node('Timer').start()
	var desired_velocity :=max_speed * direction
	var steering_vector := desired_velocity -velocity
	velocity += steering_vector * drag_factor
	position += velocity * delta
	if velocity.x != 0.0:
		last_x = velocity.x



func _on_Timer_timeout():
	move_speed = max_speed
