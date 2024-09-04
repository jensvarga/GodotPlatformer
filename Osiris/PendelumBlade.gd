extends Path2D

onready var anchor := $AnchorPoint
onready var platform := $PathFollow2D/Position2D
onready var line := $Line2D

func _ready():
	remove_child(line)
	get_tree().root.get_child(0).add_child(line)

var frame_count = 0
func _physics_process(delta):
	frame_count += 1
	
	if frame_count % 2 == 0:
		var anchor_pos = anchor.global_position
		var platform_pos = platform.global_position
		line.points = [anchor_pos, platform_pos]

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		line.queue_free()
