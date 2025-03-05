extends Area2D

onready var apep := $".."

func on_shot():
	apep.hurt()
