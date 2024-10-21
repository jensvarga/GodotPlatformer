extends Node

func _ready():
	if not Events.has_pen15:
		$"..".call_deferred("queue_free")
