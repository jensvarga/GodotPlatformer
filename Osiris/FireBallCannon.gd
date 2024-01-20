extends StaticBody2D

onready var fire_ball: = $FireBall
onready var fire_rate_timer:= $FireRateTimer

var fire_ball_start_position

func _ready():
	fire_ball_start_position = fire_ball.position
	fire_ball.activate(Vector2.UP)

func _on_FireRateCannon_timeout():
	fire_ball.position = fire_ball_start_position
	fire_ball.activate(Vector2.UP)
	fire_rate_timer.start()

func _on_VisibilityEnabler2D2_screen_entered():
	fire_rate_timer.start()

func _on_VisibilityEnabler2D2_screen_exited():
	fire_rate_timer.stop()
