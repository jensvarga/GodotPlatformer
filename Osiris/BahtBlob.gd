extends Area2D
class_name BahtBlob

const SLIMER := preload("res://Slimer.tscn")
onready var sprite := $AnimatedSprite
onready var spawn_point := $SpawnPos
const FLY := preload("res://FlySlime.tscn")

var spawn = false

func _ready():
	Events.connect("boss_died", self, "_on_boss_died")
	sprite.animation = "default"

func _physics_process(delta):
	if spawn and sprite.frame == 3:
		spawn()

func _on_BahtBlob_body_entered(body):
	if body is Player:
		body.hurt()

func _on_Timer_timeout():
	spawn = true
	sprite.animation = "Spawn"
	sprite.frame = 0

func spawn():
	var slimer := SLIMER.instance()
	get_parent().call_deferred("add_child", slimer)
	slimer.position = spawn_point.global_position
	call_deferred("queue_free")

func _on_boss_died():
	var fs = FLY.instance()
	get_parent().call_deferred("add_child", fs)
	fs.call_deferred("fly_off")
	fs.position = global_position
	queue_free()
