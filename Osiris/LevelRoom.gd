extends Node2D

export (NodePath) var follow_camera_path
export (NodePath) var snap_camera_path

export (int) var camera_limit_left = 0
export (int) var camera_limit_top = -250
export (int) var camera_limit_right = 100
export (int) var camera_limit_bottom = 175

onready var inner_collider := $RoomArea/CollisionShape2D

onready var tween := $Tween
var follow_camera
var snap_camera

export (bool) var free_cam = false

func _ready():
	if follow_camera_path:
		follow_camera = get_node(follow_camera_path)
	if snap_camera_path:
		snap_camera = get_node(snap_camera_path)
	
	update_collision_shapes()

func set_camera_limits():
	if follow_camera != null:
		#tween.interpolate_property(follow_camera, "limit_top", follow_camera.limit_top, camera_limit_top, 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		#tween.interpolate_property(follow_camera, "limit_bottom", follow_camera.limit_bottom, camera_limit_bottom, 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		#tween.interpolate_property(follow_camera, "limit_left", follow_camera.limit_left, camera_limit_left, 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		#tween.interpolate_property(follow_camera, "limit_right", follow_camera.limit_right, camera_limit_right, 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		#tween.start()
		if follow_camera is Camera2D:
			follow_camera.limit_top = camera_limit_top
			follow_camera.limit_left = camera_limit_left
			follow_camera.limit_right = camera_limit_right
			follow_camera.limit_bottom = camera_limit_bottom

func update_collision_shapes():
	if inner_collider and inner_collider.shape is RectangleShape2D:
		var inner_shape = RectangleShape2D.new()
		
		var width = camera_limit_right - camera_limit_left
		var height = camera_limit_bottom - camera_limit_top
		var pos = Vector2(camera_limit_left + width / 2, camera_limit_top + height / 2)
		
		inner_shape.extents = Vector2((width - 20) / 2, (height - 40) / 2)
		inner_collider.shape = inner_shape
		inner_collider.position = pos

func _on_RoomArea_body_entered(body):
	if body is Player:
		set_camera_limits()
	if free_cam and follow_camera is Camera2D:
		follow_camera.current = true
	elif snap_camera is Camera2D:
		snap_camera.current = true

func _on_RoomArea_body_exited(body):
	pass # Replace with function body.
