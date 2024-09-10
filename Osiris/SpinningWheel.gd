extends StaticBody2D

class_name SpinningWheel

export (float) var rotation_speed = 1

var speed: int

onready var tween := $Tween

func _ready():
	speed = rotation_speed
	
func _physics_process(delta):
	rotate(delta * rotation_speed)

func switch_direction():
	tween.interpolate_property(self, "rotation_speed", speed, speed * -1, 2, tween.TRANS_SINE, tween.EASE_IN_OUT)
	speed *= -1
	tween.start()
	
func _on_Area2D_body_entered(body):
	if body is Player:
		body.die()
