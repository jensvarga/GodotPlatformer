extends Node2D

const WHEEL = preload("res://FallingWheel.tscn")

onready var button1_sprite := $AnimatedSprite
onready var button2_sprite := $AnimatedSprite2
onready var area1 := $Area2D/CollisionShape2D
onready var area2 := $Area2D2/CollisionShape2D
onready var spawn_point := $SpawnPoint

func _ready():
	Events.connect("boss_died", self, "_on_boss_died")
	button1_sprite.animation = "Off"
	button2_sprite.animation = "Off"
	area1.set_deferred("disabled", true)
	area2.set_deferred("disabled", true)

func spawn_wheel():
	var wheel := WHEEL.instance()
	get_parent().call_deferred("add_child", wheel)
	wheel.position = spawn_point.global_position

func _on_Area2D_body_entered(body):
	if body is Player:
		if body.velocity.y > 0:
			AudioManager.play_click()
			area1.set_deferred("disabled", true)
			button1_sprite.animation = "Off"
			area2.set_deferred("disabled", false)
			button2_sprite.animation = "On"
			body.bounce(400)
			spawn_wheel()


func _on_Area2D2_body_entered(body):
	if body is Player:
		if body.velocity.y > 0:
			AudioManager.play_click()
			area1.set_deferred("disabled", false)
			button1_sprite.animation = "On"
			area2.set_deferred("disabled", true)
			button2_sprite.animation = "Off"
			body.bounce(400)
			spawn_wheel()

func _on_Area2D3_body_entered(body):
	var rando = int(rand_range(0,2))
	[area2, area1][rando].set_deferred("disabled", false)
	[button2_sprite, button1_sprite][rando].animation = "On"
	$Area2D3/CollisionShape2D.set_deferred("disabled", true)

func _on_boss_died():
	button1_sprite.animation = "Off"
	button2_sprite.animation = "Off"
	area1.set_deferred("disabled", true)
	area2.set_deferred("disabled", true)
	$ContinueTimer.start()
	

func _on_ContinueTimer_timeout():
	AudioManager.play_fanfare()
	$StaticBody2D.queue_free()
