extends Node2D

export (NodePath) var pit_path

onready var root := $".."
onready var level_area := $"../LevelArea2D/CollisionShape2D"

var connecting_level_path = "res://FallOfRa.tscn"

var started_looking = false
var jumped = false
var in_level_area = false
var pressed_button = false

func _ready():
	Transition.connect("transition_completed", self, "_on_transition_completed")
	Events.connect("ra_jumped", self, "_on_ra_jumped")
	if not Events.ra_has_jumped:
		level_area.set_deferred("disabled", true)
	else:
		root.HIDDEN = true
		root.hide()
		$"../StaticBody2D/CollisionShape2D".set_deferred("disabled", true)
		$"../InteractionZone/CollisionShape2D".set_deferred("disabled", true)
		level_area.set_deferred("disabled", false)
		
func _input(event):
	if in_level_area and event.is_action_released("ui_jump"):
		pressed_button = true
		start_selected_level()

func start_selected_level():
	AudioManager.play_random_checkpoint_sound()
	Transition.play_exit_transition()
	
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

func _on_ra_jumped():
	level_area.set_deferred("disabled", false)

func _on_LevelArea2D_body_entered(body):
	if body is OverworldPlayer:
		in_level_area = true

func _on_LevelArea2D_body_exited(body):
	if body is OverworldPlayer:
		in_level_area = false

func _on_transition_completed():
	if not pressed_button: return
	if connecting_level_path == null: return
	if not in_level_area: return
	Events.player_overworld_position = Vector2(root.global_position.x, root.global_position.y)
	get_tree().change_scene(connecting_level_path)
