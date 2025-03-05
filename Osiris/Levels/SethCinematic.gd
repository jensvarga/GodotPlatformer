extends Node2D

const FILIUS_SOLIS := preload("res://Sound/Music/Original/Deflemask/FiliusSolis.wav")
const AMBIENT_SCREECHES := preload("res://Sound/FX/MISC/ambient_screeches.wav")
const SNAKE_HISS := preload("res://Sound/FX/MISC/snake_hiss.wav")

export (String, FILE, "*.tscn") var next_scene_path

onready var show_text_timer := $ShowTextTimer
onready var between_timer := $BetweenTimer
onready var label := $CanvasLayer/Control/Label
onready var animation_player := $AnimationPlayer
onready var sprite_animator := $SpriteAnimator
onready var apep_animator := $ApepSpriteAnimator
onready var sprite := $CanvasLayer/Control/SethsEyes

func _ready():
	Transition.play_start_transition()
	AudioManager.play_music(FILIUS_SOLIS)
	AudioManager.play_sound(AMBIENT_SCREECHES)
	sprite.animation ="Closed"
	label.text = ""
	_fade_out()

onready var texts = [
	"Horus, you are blind to the truth",
	"Your father was not the great ruler you believe him to be",
	"Nor did I take his place out of spite or jealousy",
	"Osiris was weak",
	"Under his rule, Egypt faltered, and the land suffered",
	"I loved my brother, but love alone does not make a kingdom strong",
	"To rule is not to inherit, it is to prove oneself worthy",
	"Every morning, I battle the great serpent",
	"Apep",
	"Without my strength, the sun would never rise, and darkness would devour the world",
	"If you seek the throne, then take up the challenge",
	"Slay the serpent and prove you have the strength to bear the weight of kingship",
	"Do this, and I will not stand in your way", 
	"I will take my leave, vanishing into the desert, as chaos always must"
]

var text_index := 0

	
func _input(event):
	if event.is_action_released("ui_cancel"):
		_done()

func _display_line():
	label.text = texts[text_index]
	_fade_in()
	show_text_timer.start()
	
	if text_index == 3 or text_index == 6:
		sprite.animation ="Blink"
	
	if text_index == 8:
		sprite.animation ="Blink"
		apep_animator.play("FadeInApep")
		sprite_animator.play("FadeOutEyes")
		AudioManager.play_sound(SNAKE_HISS)
	
	if text_index == 11:
		sprite.animation = "Open"
		sprite_animator.play("FadeInEyes")
		apep_animator.play("FadeOutApep")
	
	if text_index == 13:
		sprite_animator.play("FadeOutEyesSlow")
		sprite.animation = "Close"
		AudioManager.fade_music()
		

func _fade_in():
	animation_player.play("FadeIn")

func _fade_out():
	animation_player.play("FadeOut")

func _done():
	get_tree().change_scene(next_scene_path)
	 
func _on_ShowTextTimer_timeout():
	_fade_out()
	if (text_index + 1) < texts.size():
		text_index += 1
		between_timer.start()
	else:
		_done()

func _on_BetweenTimer_timeout():
	_display_line()

func _on_InitDelayTimer_timeout():
	sprite_animator.play("FadeInEyes")
	sprite.animation ="Open"
	_display_line()
