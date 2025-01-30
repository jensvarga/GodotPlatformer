extends Path2D

const SOMKE_PUFF := preload("res://SmokePuffs.tscn")

onready var animator := $AnimationPlayer
onready var delay := $Timer
onready var bottom_line := $BottomLine

var in_sight := false
var player_in_trap_area := false

func _ready():
	$PathFollow2D.unit_offset = 0
	animator.play("RESET")

func Shake():
	if in_sight:
		CameraShaker.add_trauma(.4)
		AudioManager.play_boom()
		var smoke_puff := SOMKE_PUFF.instance()
		smoke_puff.position = bottom_line.global_position
		get_parent().call_deferred("add_child", smoke_puff)

func _on_VisibilityNotifier2D_screen_entered():
	in_sight = true
	animator.play("Attack")
	
func _on_VisibilityNotifier2D_screen_exited():
	in_sight = false
	delay.start()

func _on_Area2D_body_entered(body):
	if body is Player:
		body.die()
	if body is Crook:
		body.enter_death()
	elif body is Enemy:
		body.die()

func _on_Timer_timeout():
	animator.play("Attack")
