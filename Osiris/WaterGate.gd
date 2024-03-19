extends AnimatedSprite

onready var gate_collider := $StaticBody2D/CollisionShape2D

func open_gate():
	gate_collider.set_deferred("disabled", true)
	animation = "Open"

func _on_TriggerArea_body_entered(body):
	if body is Player or body is Enemy:
		open_gate()
