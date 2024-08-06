extends Path2D

func _ready():
	pass

func _on_HurtBox_body_entered(body):
	if body is Player:
		body.hurt()
