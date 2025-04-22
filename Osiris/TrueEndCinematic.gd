extends Node2D

export (Color) var sky_color = Color.deepskyblue

const PHRYGIAN_UNDERBELLY := preload("res://Sound/Music/Original/Deflemask/PhrygianUnderbelly.wav")
const BATTLE_HORN := preload("res://Sound/FX/MISC/battle_horn.wav")
const SECRETS := preload("res://Sound/FX/MISC/underground_secrets.wav")
export (String, FILE, "*.tscn") var next_scene_path

onready var pyramid_bg_sprite := $Scene1/PyramidBg
onready var sphinx_sprite := $Scene1/Sphinx
onready var text_label := $RichTextLabel
onready var text_tween := $RichTextLabel/TextTween
onready var fade_out_timer := $RichTextLabel/FadeOutTextTimer

onready var pangea_sprite := $Scene2/Pangea

onready var thot_label := $RichTextLabel2
onready var thot_tween := $RichTextLabel2/TextTween2

onready var clouds1 := $Scene3/Clouds
onready var clouds2 := $Scene3/Clouds2
onready var battle := $Scene3/Battle
onready var horse := $Scene3/Sprite

onready var scene1 := $Scene1
onready var scene2 := $Scene2

onready var tween := $Tween
onready var screen_fade := $SceneFade

onready var animation_player := $AnimationPlayer

onready var horus_texts = [
	"At last",
	"the usurper falls",
	"Egypt is whole again",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"I have rid the world of treachery!",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	""
	]

onready var thot_texts = [
	"",
	"",
	"",
	"",
	"Whole?",
	"No, Horus",
	"Seth was not only your enemy",
	"he was a pillar of the balance",
	"In destroying him",
	"you have unmade more than a god",
	"",
	"And in doing so, unbalanced the scales",
	"Where once light and shadow danced in harmony",
	"The winds twist, the deserts swallow",
	"men war without end",
	"",
	"You have won a throne",
	"but lost the world",
	"",
	"Seek the labyrinth, human",
	"Within its shifting walls lies the answer you need",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"dig deeper",
	""
	]

var text_index = -1

func _ready():
	text_label.text = ""
	thot_label.text = ""
	Transition.skip_animation()
	VisualServer.set_default_clear_color(sky_color)
	AudioManager.play_music(PHRYGIAN_UNDERBELLY)
	start_scene1()

func start_scene1():
	fade_out_screen()
	pyramid_bg_sprite.material.set_shader_param("speed", 0.001)
	sphinx_sprite.material.set_shader_param("speed", 0.0015)

func start_scene2():
	fade_out_screen()
	scene1.hide()
	pangea_sprite.play("default")
	pan_map()

func start_scene3():
	fade_out_screen()
	scene2.hide()
	AudioManager.play_sound(BATTLE_HORN)
	clouds1.material.set_shader_param("speed", -0.01)
	clouds2.material.set_shader_param("speed", -0.015)
	battle.material.set_shader_param("speed", 0.01)
	horse.material.set_shader_param("speed", 0.015)

func start_scene4():
	$Scene3.hide()
	fade_out_screen()
	animation_player.play("ZoomLab")
	AudioManager.play_sound(SECRETS)

func pan_map():
	$Scene2/Tween.interpolate_property($Scene2/Sprite, "position", Vector2(123, 105), Vector2(366, 140), 100, Tween.TRANS_CUBIC, Tween.EASE_OUT_IN)
	$Scene2/Tween.start()

func fade_out_screen():
	tween.interpolate_property(screen_fade, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 4, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

func fade_in_screen():
	tween.interpolate_property(screen_fade, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 4, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

func fade_in_text():
	text_tween.interpolate_property(text_label, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2, Tween.TRANS_SINE, Tween.EASE_OUT)
	text_tween.start()
	thot_tween.interpolate_property(thot_label, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2, Tween.TRANS_SINE, Tween.EASE_OUT)
	thot_tween.start()

func fade_out_text():
	text_tween.interpolate_property(text_label, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2, Tween.TRANS_SINE, Tween.EASE_OUT)
	text_tween.start()
	thot_tween.interpolate_property(thot_label, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2, Tween.TRANS_SINE, Tween.EASE_OUT)
	thot_tween.start()

func next_text_index():
	text_index += 1
	if horus_texts.size() > text_index:
		text_label.text = horus_texts[text_index]
		thot_label.text = thot_texts[text_index]
	
	if text_index == 3:
		fade_in_screen()
	if text_index == 5:
		start_scene2()
	if text_index == 10:
		fade_in_screen()
	if text_index == 13:
		start_scene3()
	if text_index == 16:
		fade_in_screen()
	if text_index == 19:
		start_scene4()
	if text_index == 30:
		fade_in_screen()
		AudioManager.fade_music()
	if text_index == 31:
		get_tree().change_scene(next_scene_path)

func _on_FadeInTextTimer_timeout():
	text_label.modulate = Color(1, 1, 1, 0)
	fade_in_text()
	next_text_index()
	fade_out_timer.start()
	
func _on_FadeOutTextTimer_timeout():
	fade_out_text()
