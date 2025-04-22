extends StaticBody2D

func _ready():
	if Events.has_torso and Events.has_right_hand:
		call_deferred("queue_free")
