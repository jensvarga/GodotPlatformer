extends Area2D

func on_shot():
	Events.emit_signal("damage_boss")
