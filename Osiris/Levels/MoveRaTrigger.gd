extends Area2D

onready var ra := $"../YSort/RA"

func _on_MoveRaTrigger_body_entered(_body):
	if is_instance_valid(ra):
		ra.queue_free()
	if not Events.ra_in_cave: 
		Events.ra_in_cave = true
	queue_free()
