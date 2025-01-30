extends Area2D

onready var rock1 := $KinematicBody2D
onready var rock2 := $KinematicBody2D2
onready var rock3 := $KinematicBody2D3

onready var collider1 = $KinematicBody2D/CollisionShape2D
onready var collider2 = $KinematicBody2D2/CollisionShape2D
onready var collider3 = $KinematicBody2D3/CollisionShape2D

var closed = false

func _on_LevelCompleteArea_body_entered(body):
	if body is Player and not closed:
		close_gap()
		AudioManager.stop_music()
		$Timer.start()

func _on_Timer_timeout():
	Events.emit_signal("stage_cleared")

func close_gap():
	closed = true
	AudioManager.play_boom()
	rock1.show()
	collider1.set_deferred("disabled", false)
	yield(get_tree().create_timer(0.5), "timeout")
	AudioManager.play_boom()
	rock2.show()
	collider2.set_deferred("disabled", false)
	yield(get_tree().create_timer(0.5), "timeout")
	AudioManager.play_boom()
	rock3.show()
	collider3.set_deferred("disabled", false)
