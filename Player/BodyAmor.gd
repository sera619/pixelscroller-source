extends Node
class_name BodyAmor


export (Resource) var practice_amor
signal bodyamor_changed
signal defense_changed


var current_bodyamor = null
var defense = defense setget set_defense

# Called when the node enters the scene tree for the first time.
func _ready():
	if current_bodyamor == null:
		equip_bodyamor(practice_amor)

func equip_bodyamor(new_bodyamor):
	current_bodyamor = new_bodyamor
	set_defense(current_bodyamor.amor_defense)
	DataManager.player_data.bodyamor = current_bodyamor
	emit_signal("bodyamor_changed")
	

func set_defense(new_defense):
	defense = int(new_defense)
	emit_signal("defense_changed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
