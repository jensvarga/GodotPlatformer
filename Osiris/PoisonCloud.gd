extends Area2D

func _ready():
	var rand_speed := rand_range(1, 3)
	$Sprite.material.set_shader_param("speed", rand_speed)
	
func _on_PoisonCloud_body_entered(body):
	if body is Player:
		body.hurt()
