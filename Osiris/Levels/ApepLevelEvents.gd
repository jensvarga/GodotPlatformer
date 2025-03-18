extends Node2D

const TIMOREM_DEUM := preload("res://Sound/Music/Original/Deflemask/TimoremDeum.wav")
const SNAKE_QUAKE := preload("res://ApepEarthquake.tscn")

onready var animation_player := $"../AnimationPlayer"
onready var apep := $"../Apep"
onready var tween := $"../Tween"

onready var bite_attack_node := $"../BiteAttack"
onready var bite_sprite := $"../BiteAttack/Sprite"
onready var telegraph_bite_sprite := $"../BiteAttack/Telegraph"
onready var telegraph_timer := $"../BiteAttack/TelegraphTimer"
onready var quake_position := $"../BiteAttack/QuakePosition"
onready var bounce_timer := $BounceTimer
onready var bounce_timer_2 := $BounceTimer2

onready var snakey_snake := $"../ApepSnaker"
onready var snakey_snake_2 := $"../ApepSnaker2"
onready var snakey_snake_3 := $"../ApepSnaker3"
onready var snakey_snake_4 := $"../ApepSnaker4"
onready var snake_timer := $SnakeTimer
onready var snake_done_timer := $SnakeDoneTimer

onready var spitter_right := $"../ApepSpitting"
onready var spitter_left := $"../ApepSpitting2"

var nr_of_bites = 3
var boss_dead = false

func _ready():
	Events.boss_hit_points = 12
	apep.connect("BiteAttack", self, "_on_BiteAttack")
	apep.connect("SnakeAttack", self, "_on_SnakeAttack")
	apep.connect("SpitAttack", self, "_on_SpitAttack")
	Events.connect("boss_died", self, "_on_boss_died")
	Events.has_talaria = true
	Events.has_power_crook = true
	telegraph_bite_sprite.animation = "default"
	call_deferred("reset_snakers")
	
	if Events.check_point_reached:
		animation_player.play("SkipIntro")
	else:
		animation_player.play("Intro")

func play_intro_scream():
	AudioManager.play_aphopis_entrance_sound()

func enter_intro():
	play_intro_scream()
	apep.enter_intro()

func start_music():
	AudioManager.play_music(TIMOREM_DEUM)

func enter_idle():
	AudioManager.play_aphopis_hurt_sound()
	Events.check_point_reached = true
	apep.enter_idle()

func _on_BiteAttack():
	nr_of_bites = int(rand_range(3, 5))
	_bite_attack()

func _bite_attack():
	if nr_of_bites > 0:
		bite_attack_node.position.x = Events.player.global_position.x
		telegraph_bite_sprite.animation = "Telegraph"
		telegraph_timer.start()
		nr_of_bites -= 1
		
		if bite_attack_node.position.x > 0:
			bite_attack_node.scale.x = -1
		else:
			bite_attack_node.scale.x = 1
	else:
		apep.emit_signal("BiteAttackDone")

func _on_TelegraphTimer_timeout():
	tween.interpolate_property(bite_sprite, "position:y", bite_sprite.position.y, bite_sprite.position.y - 250, 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	telegraph_bite_sprite.animation = "default"
	CameraShaker.add_trauma(0.4)
	bounce_timer.start()
	
	var snake_quake := SNAKE_QUAKE.instance()
	add_child(snake_quake)
	snake_quake.position = quake_position.global_position
	AudioManager.play_boom()

func _on_BounceTimer_timeout():
	tween.interpolate_property(bite_sprite, "position:y", bite_sprite.position.y, 0, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	bounce_timer_2.start()

func _on_BounceTimer2_timeout():
	if boss_dead:
		return
	_bite_attack()
	
func _on_SpitAttack():
	if boss_dead:
		return
	var ran = rand_range(-1, 1)
	if ran < 0:
		animation_player.play("SpitLeft")
	else:
		animation_player.play("SpitRight")

func _on_SnakeAttack():
	if boss_dead:
		return
	var ran = rand_range(0, 4)
	
	if ran <= 1:
		snakey_snake.active = true
	elif ran <= 2:
		snakey_snake_2.active = true
	elif ran <= 3:
		snakey_snake_3.active = true
	else:
		snakey_snake_4.active = true
		
	snake_timer.start()
	snake_done_timer.start()

func _on_SnakeTimer_timeout():
	reset_snakers()

func reset_snakers():
	snakey_snake.reset()
	snakey_snake_2.reset()
	snakey_snake_2.reset()
	snakey_snake_4.reset()

func _on_SnakeDoneTimer_timeout():
	apep.emit_signal("SnakeAttackDone")

func spit_right():
	spitter_right.emit_signal("spit")

func spit_left():
	spitter_left.emit_signal("spit")

func attack_done():
	apep.emit_signal("BiteAttackDone")

func _on_boss_died():
	boss_dead = true
	animation_player.play("BossDied")
