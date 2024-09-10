extends Node2D

onready var room7_shape := $"../Room7/CollisionShape2D"
onready var room8_shape := $Room8/CollisionShape2D
onready var block1 := $Room8/KinematicBody2D/CollisionShape2D
onready var animation_player := $"../AnimationPlayer"
onready var sphinx := $"../StaticSphinx"
onready var scroll_screen_collider := $"../Path2D/PathFollow2D/Area2D/CollisionShape2D"
onready var anchor := $"../Path2D/PathFollow2D/Hor-em-AkhetPath/Hor-em-AkhetAnhor"

const HOR_EM = preload("res://Hor-em-Akhet.tscn")
var hor_em_akhet: HorEmAkhet = null

var scrolling_screen = false
var frame_count = 0

func _ready():
	room8_shape.set_deferred("disabled", true)
	block1.set_deferred("disabled", true)
	animation_player.play("RESET")

func _physics_process(delta):
	if scrolling_screen:
		frame_count += 1
		if frame_count % 2 == 0:
			scroll_screen_collider.set_deferred("disabled", true)
		else:
			scroll_screen_collider.set_deferred("disabled", false)

func _on_Area2D_body_entered(body):
	if body is Player:
		room7_shape.set_deferred("disabled", true)
		room8_shape.set_deferred("disabled", false)
		block1.set_deferred("disabled", false)
		AudioManager.fade_music()
		sphinx.go = true
		$Area2D/CollisionShape2D.set_deferred("disabled", true)

func _on_ScrollTrigger_body_entered(body):
	if body is Player:
		AudioManager.play_hor_em_scream()
		hor_em_akhet = HOR_EM.instance()
		anchor.add_child(hor_em_akhet)
		hor_em_akhet.emit_signal("on")
		animation_player.play("MoveHor-em")
		$ScrollTrigger/CollisionShape2D.set_deferred("disabled", true)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "MoveHor-em":
		hor_em_akhet.emit_signal("off")
		$RevealTimer.start()
	else:
		scrolling_screen = false

func _on_RevealTimer_timeout():
	hor_em_akhet.emit_signal("on")
	scrolling_screen = true
	animation_player.play("AutoScroll")
