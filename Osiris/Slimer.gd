extends KinematicBody2D

const SPEED = 25
const GRAVITY = 540
const FLY := preload("res://FlySlime.tscn")

var velocity = Vector2.ZERO
onready var sprite := $AnimatedSprite

func _ready():
	Events.connect("boss_died", self, "_on_boss_died")

func _physics_process(delta):
	if Events.player == null:
		return
	var player_position := Events.player.global_position
	var direction = sign(player_position.x - global_position.x)
	
	velocity.x = direction * SPEED
	add_gravity(delta)
	
	if not sprite.flip_h and direction > 0:
		sprite.flip_h = true
	if sprite.flip_h and direction < 0:
		sprite.flip_h = false
		
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()
		var dir = Vector2(-velocity.x, -1).normalized()
		body.knockback(dir * 200)
	
func add_gravity(delta):
	velocity.y += GRAVITY * delta

func _on_boss_died():
	var fs = FLY.instance()
	get_parent().call_deferred("add_child", fs)
	fs.call_deferred("fly_off")
	fs.position = global_position
	queue_free()
