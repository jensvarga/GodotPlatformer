extends Label

onready var boss := $"../../Path2D/PathFollow2D/Aphopis"
var counter = 1
var is_stopped := false

func _process(delta: float) -> void:
	text = "HP: " + str(boss.hit_points)

