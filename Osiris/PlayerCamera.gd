# Thanks to Nick Vatanshenas for this amazing solution 
# explaiend in https://www.youtube.com/watch?v=lPJMj-ov7ys

extends Camera2D

class_name PlayerCamera

export (float) var follow_smothing = 0.04
var smoothing: float

var current_room_center: Vector2
var current_room_size: Vector2

onready var view_size: Vector2 = get_viewport_rect().size
var zoom_view_size: Vector2

func _ready():
	smoothing_enabled = false
	smoothing = 1
	yield(get_tree().create_timer(0.1),"timeout")
	smoothing = follow_smothing

func _physics_process(delta):
	zoom_view_size = view_size * zoom
	
	var target_position := calculate_target_position(current_room_center, current_room_size)
	position = lerp(position, target_position, smoothing)
	
func calculate_target_position(room_center: Vector2, room_size: Vector2) -> Vector2:
	var x_margin: float = (room_size.x - zoom_view_size.x) / 2
	var y_margin: float = (room_size.y - zoom_view_size.y) / 2
	
	var return_position: Vector2 = Vector2.ZERO
	
	if x_margin <= 0:
		return_position.x = room_center.x
	else:
		var left_limit: float = room_center.x - x_margin
		var right_limit: float = room_center.x + x_margin
		return_position.x = clamp(Events.player.position.x, left_limit, right_limit)
		
	if y_margin <= 0:
		return_position.y = room_center.y
	else:
		var top_limit: float = room_center.y - y_margin
		var bottom_limit: float = room_center.y + y_margin
		return_position.y = clamp(Events.player.position.y, top_limit, bottom_limit)
	
	return return_position
	