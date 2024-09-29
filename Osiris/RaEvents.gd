extends Node2D

export (NodePath) var pit_path

onready var root := $".."

var started_looking = false
var jumped = false

func _process(delta):
	if root.dialouge_index > 0 and not started_looking:
		started_looking = true
	
	if started_looking and root.dialouge_index == 0 and not jumped:
		jumped = true
		var pit = get_node(pit_path)
		if pit is PitOfDoom:
			pit.jump = true
			AudioManager.play_random_jump_sound()
			root.HIDDEN = true
			root.hide()
			$"../StaticBody2D/CollisionShape2D".set_deferred("disabled", true)
			$"../InteractionZone/CollisionShape2D".set_deferred("disabled", true)
			Events.emit_signal("ra_jumped")
