extends Node2D

onready var sprites := $Sprites
onready var collider := $StaticBody2D/CollisionShape2D
onready var tween := $Tween
onready var timer := $Timer

var closed = false

func _ready():
	collider.set_deferred("disabled", true)
	sprites.hide()

func _on_Area2D_body_entered(body):
	if not closed and body is Player:
		closed = true
		sprites.show()
		collider.set_deferred("disabled", false)
		tween.interpolate_property(sprites, "position:x", sprites.position.x, (sprites.position.x + 32 * 8), 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()
		AudioManager.fade_music()
		timer.start()

func _on_Timer_timeout():
	Events.emit_signal("stage_cleared")
