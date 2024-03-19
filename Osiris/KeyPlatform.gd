extends Path2D

onready var animation_player := $AnimationPlayer

func _ready():
	pass # Replace with function body.

func play_bounce():
	if animation_player.assigned_animation == "Bounce":
		animation_player.play()
	else:
		animation_player.play("Bounce")

func _on_KeyArea_body_entered(body):
	if body is Player:
		if body.item_instsance is Key:
			body.item_instsance.use()
			play_bounce() 

func _on_KeyArea_body_exited(body):
	if body is Player:
		animation_player.stop(false)
