extends Area2D

onready var root := $".."

func on_shot():
	root.die()
