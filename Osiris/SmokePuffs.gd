extends Node2D

onready var sprite := $AnimatedSprite

var second_round = false

func _ready():
	sprite.animation = "default"
	sprite.frame = 0
	sprite.playing = true
	
func _physics_process(delta):
	if sprite.frame == 3 and second_round:
		call_deferred("queue_free")
	elif sprite.frame == 3:
		second_round = true
