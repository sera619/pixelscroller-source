extends KinematicBody2D
class_name DirectFollowEnemy


export var stop_radius := 3.0
export var slow_radius := 70.0
export var move_speed := 220.0

onready var stats = $EnemyStats
onready var health_plate =$HealthPlate
onready var health_bar = $HealthPlate/HealthBar



var player: Player = null
var boost_speed:= 360.0
var max_speed := move_speed
var velocity = Vector2.ZERO
var last_x := 0.0
var drag_factor := 0.1



func _ready():
	stats.connect("health_changed", self, 'update_healthbar')

func update_healthbar():
	health_bar.rect_size.x = 46 * stats.health / stats.max_health


func _input(event):
	if event.is_action_pressed("sword_attack"):
		move_speed = boost_speed
		$AtkTimer.start(2.0)

func _process(delta):
	if last_x < 0.0:
		$Body.flip_h = false
	else:
		$Body.flip_h = true
#	var direction :=Input.get_vector("move_l",'move_r',"ui_up",'ui_down')
#	if Input.is_action_just_pressed("attack"):
#		max_speed = boost_speed
#		get_node('Timer').start()
#	var desired_velocity :=max_speed * direction
#	var steering_vector = desired_velocity -velocity
#	velocity += steering_vector * drag_factor
#	position += velocity * delta
#	if velocity.x != 0.0:
#		last_x = velocity.x



func _physics_process(delta: float) -> void:
	var target_global_position : Vector2 = Steering.target_position
	
	if global_position.distance_to(target_global_position) < stop_radius:
		return # idle
	
	# moving 
	#velocity = Steering.follow(
	#	velocity,
	#	global_position,
	#	target_global_position,
	#	max_speed
	#)
	velocity = Steering.arrive_to(
		velocity,
		global_position,
		target_global_position,
		move_speed,
		slow_radius
		)
	last_x = velocity.x
	velocity = move_and_slide(velocity)





func _on_PlayerDetect_body_entered(body):
	if !body.name == 'Player':
		return
	else:
		player = body

func _on_PlayerDetect_body_exited(body):
	if !body.name == 'Player':
		return
	else:
		player = null


func _on_HitBox_area_entered(area):
	pass # Replace with function body.


func _on_AtkTimer_timeout():
	move_speed = max_speed
