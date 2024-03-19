extends Path2D

export (String, "Bounce", "Loop", "Stationary") var ANIMATION = "Bounce"
 
onready var animation_player := $AnimationPlayer

func _ready():
	if ANIMATION == "Bounce":
		animation_player.play("Bounce")
	elif ANIMATION == "Loop":
		animation_player.play("RESET")
	elif ANIMATION == "Stationary":
		animation_player.play("Stationary")
