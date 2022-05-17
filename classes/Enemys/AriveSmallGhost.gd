extends KinematicBody2D
export var stop_radius := 64.0
export var slow_radius := 160.0
export var move_speed := 220.0
export (NodePath) var target_node
onready var target: KinematicBody2D = get_node(target_node)

var current_target
var player: Player = null
var boost_speed:= 260.0
var max_speed := move_speed
var velocity = Vector2.ZERO
var last_x := 0.0
var drag_factor := 0.1
var target_global_position: Vector2

func _ready():
	current_target = self

func _process(delta):
	if last_x > 0:
		$Body.flip_h = true
	else:
		$Body.flip_h = false

func _input(event):
	if event.is_action_pressed("attack"):
		if current_target != target:
			current_target = target
		else:
			current_target = self

func _physics_process(delta: float) -> void:
	target_global_position = current_target.global_position
	
	if global_position.distance_to(target_global_position) < stop_radius:
		return # idle
	velocity = Steering.arrive_to(
		velocity,
		global_position,
		target_global_position,
		max_speed,
		slow_radius
		)
	last_x = velocity.x
	velocity = move_and_slide(velocity)


func _on_PlayerDetect_body_entered(body):
	if body.name != 'Player':
		return
	else:
		player = body

func _on_PlayerDetect_body_exited(body):
	if body.name !='Player':
		return
	else:
		player = null
