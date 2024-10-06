extends Node2D

onready var sprite := $Sprite
var collected = false

func _ready():
	if Events.has_power_crook:
		collected = true
		sprite.hide()
		$Area2D/CollisionShape2D.set_deferred("disabled", true)

func _on_Area2D_body_entered(body):
	if body is Player and not collected:
		AudioManager.play_power_up()
		Events.emit_signal("pick_up_power_crook")
		collected = true
		sprite.hide()
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
