extends AnimatedSprite

const SPEED = 75
var _target = Vector2.ZERO
var _baht = null
var _tracking = true

func set_target(baht):
	self._target = baht.fire_pos.global_position
	self._baht = baht

func fly_off():
	self._target = Vector2(global_position.x, global_position.y - 500)
	self._tracking = false

func _physics_process(delta):
	if global_position == _target and _tracking:
		_baht.emit_signal("slime_returned")
		call_deferred("queue_free")
	
	global_position = global_position.move_toward(_target, SPEED * delta)
	look_at(_target)

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()
