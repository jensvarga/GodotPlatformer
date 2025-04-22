extends AnimatedSprite

var even = true

func _process(delta):
	if even:
		look_at_player()
		
	even = !even

func look_at_player():
	print("look")
	if Events.player.global_position.x < global_position.x:
		animation = "Left"
	else:
		animation = "Right"
