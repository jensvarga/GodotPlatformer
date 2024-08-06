tool
extends ReferenceRect

onready var base := $".."
onready var label := $Label

func _ready():
	if Engine.editor_hint:
		update_reference_rect()

func _process(delta):
	if Engine.editor_hint:
		update_reference_rect()

func update_reference_rect():
	if base != null:
		rect_position = Vector2(base.camera_limit_left, base.camera_limit_top)
		rect_min_size = Vector2(base.camera_limit_right - base.camera_limit_left, base.camera_limit_bottom - base.camera_limit_top)
	if label != null:
		label.text = base.name
