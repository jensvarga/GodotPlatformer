extends Area2D

onready var animation_player := $"../AnimationPlayer"

var swom = false

func _ready():
	pass

func _on_Room10_body_entered(body):
	if body is Player and not swom:
		animation_player.play("Whalecum")
		swom = true
