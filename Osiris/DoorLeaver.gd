extends StaticBody2D

const CHAIN_PULL := preload("res://Sound/FX/MISC/chain_pull.wav")

onready var sprite := $Sprite
onready var chain_sprite := $ChainSprite
onready var timer := $Timer
onready var animation_player := $AnimationPlayer

func on_shot():
	sprite.animation = "Flicked"
	AudioManager.play_click()
	AudioManager.play_sound(CHAIN_PULL)
	chain_sprite.animation = "Pull"
	animation_player.play("OpenGate")
	timer.start()

func _on_Timer_timeout():
	chain_sprite.animation = "default"
