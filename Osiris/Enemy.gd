extends KinematicBody2D

class_name Enemy

enum { STASIS, MOVE, SHELL, KICKED, FLYING }
var state = MOVE
var previous_state = MOVE

func die():
	queue_free()

func attack(body):
	pass
