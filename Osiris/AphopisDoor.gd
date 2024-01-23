extends StaticBody2D

onready var sprite_front: = $AnimatedSpriteFront
onready var sprite_back: = $AnimatedSpriteBack
onready var open_collider: = $CollisionShape2D2
onready var closed_collider: = $CollisionShape2D
onready var fire_ball: = $FireBall
onready var troll_timer: = $TrollTimer
onready var door_timer: = $DoorTimer

var open = false

func _ready():
	fire_ball.deactivate()
	
func open_door():
	open = true
	sprite_front.animation = "Open"
	sprite_back.animation = "Open"
	CameraShaker.add_trauma(0.3)
	AudioManager.play_stone_door_sound()
	door_timer.start()
	troll_timer.start()
	

func _on_Area2D_body_entered(body):
	if body is Player and not open:
		open_door()


func _on_TrollTimer_timeout():
	CameraShaker.add_trauma(0.3)
	fire_ball.activate(Vector2.RIGHT)

func _on_DoorTimer_timeout():
	closed_collider.set_deferred("disabled", true)
	open_collider.set_deferred("disabled", false)

