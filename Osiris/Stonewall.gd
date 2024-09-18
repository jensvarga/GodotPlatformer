extends StaticBody2D

export (int) var hp = 6

const PARTICLES = preload("res://StonrwallParticles.tscn")

var invincable = false

onready var animation_player := $AnimationPlayer
onready var timer := $invincableTimer

func on_fireballed():
	if invincable:
		return
	if (hp - 1) <= 0:
		explode()
	else:
		CameraShaker.add_trauma(0.4)
		timer.start()
		animation_player.play("Hurt")
		hp -= 1
		invincable = true
	
func explode():
	CameraShaker.add_trauma(0.6)
	AudioManager.play_boom()
	var particles = PARTICLES.instance()
	get_parent().call_deferred("add_child", particles)
	particles.position = global_position
	queue_free()

func _on_invincableTimer_timeout():
	invincable = false
