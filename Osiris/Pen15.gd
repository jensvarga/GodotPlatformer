extends Node2D

var collected = false

onready var sprite := $Sprite
onready var eggplant := $Sprite2

func _ready():
	if Events.family_friendly_mode:
		sprite.hide()
		eggplant.show()
	else:
		sprite.show()
		eggplant.hide()

func open_website():
	var url = "https://www.example.com"
	OS.shell_open(url)

func _on_Area2D_body_entered(body):
	if body is Player and not collected:
		sprite.hide()
		eggplant.hide()
		Events.has_pen15 = true
		AudioManager.play_random_checkpoint_sound()
		Events.emit_signal("stage_cleared")
		queue_free()
