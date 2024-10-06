extends RigidBody2D

const SCORP := preload("res://Scorpiu.tscn")

var inactive = true

func transform():
	var scorp = SCORP.instance()
	get_parent().call_deferred("add_child", scorp)
	scorp.position = global_position
	AudioManager.play_random_hit_sound()

func on_shot():
	transform()
	queue_free()

func _on_Area2D_body_entered(body):
	if inactive:
		return
	if body is Player:
		body.hurt()
	
	transform()
	queue_free()

func _on_Timer_timeout():
	inactive = false
