extends KinematicBody2D

class_name Enemy

enum { STASIS, MOVE, SHELL, KICKED }
var state = MOVE
var previous_state = MOVE

func die():
	queue_free()
