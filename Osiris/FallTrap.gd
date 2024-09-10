extends Path2D

onready var tween := $Tween
onready var path_follow := $PathFollow2D

func _on_Area2D_body_entered(body):
	if body is Player:
		print("enter")
		tween.interpolate_property(path_follow, "unit_offset", 0, 1, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		$Area2D/CollisionShape2D.set_deferred("disabled", true)


func _on_Tween_tween_all_completed():
	queue_free()
