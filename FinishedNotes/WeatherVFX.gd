extends Control


const fogg_shader = preload("res://materials/shader/Shader_Fogg.tscn")
onready var animPlayer = $AnimationPlayer


func _ready():
	GameManager.weather = self


func show_fogg():
	var fogg = fogg_shader.instance()
	self.add_child(fogg)
	animPlayer.play("Show")


func clear_weather():
	if self.get_child_count() == 1:
		return
	else:
		animPlayer.play("Hide")
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hide":
		self.get_child(1).queue_free()
