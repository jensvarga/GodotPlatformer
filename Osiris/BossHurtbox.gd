extends KinematicBody2D

class_name Boss

onready var main_script: = $"../../.."

func hurt():
	main_script.hurt()
