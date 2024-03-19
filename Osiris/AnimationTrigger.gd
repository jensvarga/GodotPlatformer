extends Area2D

onready var animation_player := $"../TurtleAnimationPlayer"
onready var path_follow := $"../TurtlePath/PathFollow2D"
onready var turtle := $"../TurtlePath/PathFollow2D/Turtle"

func _ready():
	animation_player.stop()
	path_follow.unit_offset = 0.01


func _on_AnimationTrigger_body_entered(body):
	if body is Player:
		animation_player.play("SwimPath")
		turtle.swim()
