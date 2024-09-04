extends Node2D

onready var tween := $Tween

var lowered = false

func _ready():
	Events.connect("killed_miniboss", self, "_on_killed_miniboss")
	
	if Events.check_point_reached:
		position.y += 270
		lowered = true
	
func _on_killed_miniboss():
	if not lowered:
		tween.interpolate_property(self, "position:y", position.y, (position.y + 270), 3, Tween.TRANS_SINE, Tween.EASE_IN_OUT, Tween.EASE_IN)
		tween.start()
		lowered = true
