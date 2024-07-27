extends Node2D

var amplitude = 5
var speed = .5
var initial_position: Vector2
var collected = false

onready var sprite := $Sprite

func _ready():
	initial_position = position

func _physics_process(delta):
	var offset = amplitude * sin(speed * OS.get_ticks_msec() * 0.001)
	var new_position = initial_position + Vector2(0, offset)
	position = new_position
	
func _on_Area_body_entered(body):
	if Events.player_hit_points == 3:
		return
		
	if body is Player and not collected:
		collected = true
		sprite.hide()
		Events.emit_signal("pick_up_ankh")
		AudioManager.play_random_checkpoint_sound()
