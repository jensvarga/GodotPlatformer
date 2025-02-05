extends Area2D

class_name BookProjectile

const FIRE := preload("res://BookFire.tscn")
const SPEED = 200.0
var direction = Vector2.ZERO
var velocity = Vector2.ZERO

func set_direction(_direction: Vector2, _rotation: float):
	direction = _direction.normalized()
	rotation = _rotation

func _physics_process(delta):
	velocity = SPEED * direction

	translate(velocity * delta)
	rotation = direction.angle()

func spawn_fire():
	AudioManager.play_boom()
	CameraShaker.add_trauma(.3)
	var fire := FIRE.instance()
	fire.position = Vector2(global_position.x, global_position.y + 10)
	get_parent().call_deferred("add_child", fire)
	call_deferred("queue_free")

func _on_BookProjectile_body_entered(body):
	if body is Player:
		body.hurt()
		spawn_fire()
	if body.name != "Eratosthenes":
		spawn_fire()
