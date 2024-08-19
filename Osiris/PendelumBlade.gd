extends Path2D

onready var anchor := $AnchorPoint
onready var platform := $PathFollow2D/Position2D
onready var line := $Line2D

func _ready():
	remove_child(line)
	get_tree().root.get_child(0).add_child(line)

func _physics_process(delta):
	var anchor_pos = anchor.global_position
	var platform_pos = platform.global_position
	line.points = [anchor_pos, platform_pos]
