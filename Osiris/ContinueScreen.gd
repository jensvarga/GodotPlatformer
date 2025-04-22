extends Node2D

export (Color) var sky_color = Color.deepskyblue
export (Color) var select_color = Color.deepskyblue
export (Color) var deselect_color = Color.deepskyblue
export (Color) var time_up_color = Color.deepskyblue

const CONTINUE := preload("res://Sound/Music/Original/Deflemask/Continue.wav")
const BELL := preload("res://Sound/FX/MISC/church_bell.wav")
const LAUGHT := preload("res://Sound/FX/MISC/seth_laugh.wav")

onready var numbers_sprite := $AnimatedSprite
onready var horus_sprite := $HorusSprite
onready var yes_arrow := $Control/YesArrow
onready var yes_text := $Control/Label2
onready var no_arrow := $Control/NoArrow
onready var no_text := $Control/Label3
onready var timer := $Timer

var yes_selected = true
var yes_chosen = false
var time_up = false

func _ready():
	Transition.hide_pixelation()
	VisualServer.set_default_clear_color(sky_color)
	AudioManager.play_music(CONTINUE)
	numbers_sprite.play("default")
	horus_sprite.play("default")
	select_yes()

func _input(event):
	if time_up:
		return
		
	if event.is_action_released("ui_right"):
		select_no()
	if event.is_action_released("ui_left"):
		select_yes()
	if yes_selected && (event.is_action_released("ui_accept") or event.is_action_released("ui_fire") or event.is_action_released("ui_jump")):
		continue_selected()
	if !yes_selected && (event.is_action_released("ui_accept") or event.is_action_released("ui_fire") or event.is_action_released("ui_jump")):
		choose_no()

func continue_selected():
	yes_chosen = true
	numbers_sprite.stop()
	horus_sprite.animation = "Continue"
	AudioManager.stop_music()
	AudioManager.play_power_up()
	timer.start()

func choose_no():
	numbers_sprite.stop()
	horus_sprite.animation = "Dead"
	AudioManager.stop_music()
	AudioManager.play_sound(BELL)
	AudioManager.play_sound(LAUGHT)
	time_up()
	
func select_no():
	yes_selected = false
	yes_arrow.hide()
	no_arrow.show()
	no_text.add_color_override("font_color", select_color)
	yes_text.add_color_override("font_color", deselect_color)

func select_yes():
	yes_selected = true
	yes_arrow.show()
	no_arrow.hide()
	no_text.add_color_override("font_color", deselect_color)
	yes_text.add_color_override("font_color", select_color)

func time_up():
	time_up = true
	no_text.add_color_override("font_color", time_up_color)
	yes_text.add_color_override("font_color", time_up_color)
	no_arrow.add_color_override("font_color", time_up_color)
	yes_arrow.add_color_override("font_color", time_up_color)
	timer.start()

func _on_AnimatedSprite_frame_changed():
	if numbers_sprite.frame != 10:
		AudioManager.play_sound(BELL)
	else:
		choose_no()

func _on_Timer_timeout():
	if yes_chosen:
		Events.continue_game()
	else:
		Events.dont_continue()
