extends Area2D

class_name SphinxBody

onready var root := $"../../.."

func hurt():
	root.emit_signal("hurt")
