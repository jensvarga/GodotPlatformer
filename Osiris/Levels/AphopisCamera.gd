extends Camera2D

func _ready():
	Events.connect("checkpoint_reached", self, "_on_checkpoint_reached")
	if Events.check_point_reached:
		limit_right = 500

func _on_checkpoint_reached():
	limit_right = 500
