extends Node2D

var amplitude = 5
var speed = .5
var initial_position: Vector2
var collected = false

var ankh = true

onready var sprite := $Sprite
onready var eye_sprite := $Sprite2

func _ready():
	initial_position = position

func _physics_process(delta):
	var offset = amplitude * sin(speed * OS.get_ticks_msec() * 0.001)
	var new_position = initial_position + Vector2(0, offset)
	position = new_position
	
func _on_Area_body_entered(body):
	if not ankh:
		Events.emit_signal("gained_life")
	elif body is Player and not collected:
		Events.emit_signal("pick_up_ankh")
		
	collected = true
	eye_sprite.hide()
	sprite.hide()
	$Area/CollisionShape2D.set_deferred("disabled", true)
	AudioManager.play_random_checkpoint_sound()
	$DestroyTimer.start()

func _on_DestroyTimer_timeout():
	queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	if Events.player_hit_points >= Events.max_player_hit_points:
		ankh = false
		sprite.hide()
		eye_sprite.show()
	else:
		ankh = true
		sprite.show()
		eye_sprite.hide()
