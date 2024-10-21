extends Sprite
class_name CensorBar

func _ready():
	if Events.family_friendly_mode:
		show()
	else:
		hide()
