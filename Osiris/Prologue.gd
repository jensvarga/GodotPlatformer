extends Node2D

export (String, FILE, "*.tscn") var next_scene_path

onready var tween := $Tween
onready var text_label := $CanvasLayer/RichTextLabel
onready var animation_player := $AnimationPlayer
onready var timer1 := $Timer1
onready var timer2 := $Timer2

const display_time = 5

var is_active = true
var _index

onready var texts = [
	"In the ancient lands of Egypt, where the sands whisper of gods and kings, there reigned Osiris",
	"The noble ruler of the divine Naiad",
	"Under his wise and benevolent rule, the kingdom flourished",
	"", # Scene 1 - 20s
	"But as Egypt thrived, dark whispers stirred in shadowed hearts",
	"Jealousy began to take root. In the halls of power",
	"A brother's envy grew",  # Scene 2 - 15s
	"Seth, the strong, the warrior",
	"He believed it was his strength that should command the throne, not the wisdom of Osiris",
	"Seth struck down Osiris",
	"But in his arrogance, he did not see all", # Scene 3 - 20
	"Isis, the queen, had escaped, and with her...",
	"A secret",
	"A rightful heir to the throne of Egypt yet lived", # Scene 4 - 15s
	"",
	"",
	"Father, I will avenge you" # Scene 5 - 20s 
]

func _ready():
	start_displaying_text()
	AudioManager.play_sec_semper()

func start_displaying_text():
	_show_next_text(0)

func _show_next_text(index):
	if index >= texts.size():
		return
	_index = index
	text_label.text = texts[index]
	
	tween.stop_all()
	tween.interpolate_property(text_label, "modulate:a", 0.0, 1.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	timer1.wait_time = display_time
	timer1.start()
	#yield(get_tree().create_timer(display_time), "timeout")

	#tween.interpolate_property(text_label, "modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.start()

	#yield(tween, "tween_completed")
	#_show_next_text(index + 1)

func _on_Timer1_timeout():
	tween.stop_all()
	tween.interpolate_property(text_label, "modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	timer2.wait_time = 0.5
	timer2.start()

func _on_Timer2_timeout():
	_show_next_text(_index + 1)

func _exit_tree():
	is_active = false
	
func _input(event):
	if event.is_action_released("ui_cancel"):
		get_tree().change_scene(next_scene_path)

func _on_Scene1_animation_finished(anim_name):
	match anim_name:
		"Scene1":
			animation_player.play("Scene2")
		"Scene2":
			animation_player.play("Scene3")
		"Scene3":
			animation_player.play("Scene4")
		"Scene4":
			animation_player.play("Scene5")
		"Scene5":
			animation_player.play("Scene6")
		"Scene6":
			get_tree().change_scene(next_scene_path)

func play_thunder_clap():
	AudioManager.play_random_thunder()
	
func fade_music():
	AudioManager.fade_music()

func play_orgasms():
	AudioManager.play_orgasms()

