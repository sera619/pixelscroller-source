class_name ShakingCamera2D
extends Camera2D

# The maximum offset applied to the camera in pixels.
export var max_amplitude := 16.0
export (bool) var develop_mode = false

var shake_intensity := 0.0 setget set_shake_intensity
var _noise := preload("res://materials/camera_noise.tres")

onready var cam_anim = $CamAnimantion

func _init() -> void:
	_noise.seed = randi()



func _process(_delta):
	if develop_mode:
		if Input.is_key_pressed(KEY_H):
			self.zoom.x += 0.2 
			self.zoom.y += 0.2
		elif Input.is_key_pressed(KEY_G):
			self.zoom.x -= 0.2 
			self.zoom.y -= 0.2 
	else:
		pass


func _physics_process(delta: float) -> void:
	set_shake_intensity(shake_intensity - delta)
	var time_elapsed := OS.get_ticks_msec() / 20.0
	var random_direction := Vector2(
		_noise.get_noise_2d(time_elapsed, time_elapsed * 3.0),
		_noise.get_noise_2d(time_elapsed * 2.0, time_elapsed)
	).normalized()
	offset = random_direction * max_amplitude * shake_intensity * shake_intensity


func set_shake_intensity(intensity: float) -> void:
	shake_intensity = clamp(intensity, 0.0, 1.0)
	var is_shaking := not is_equal_approx(shake_intensity, 0.0)
	set_physics_process(is_shaking)


func lights_off():
	cam_anim.play("light2dark")

func lights_on():
	cam_anim.play("dark2light")
