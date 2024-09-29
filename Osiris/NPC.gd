extends Node2D

export (String) var NAME = "RA"
export (bool) var HIDDEN = false
export (String, FILE, "*.png") var PORTRAIT_PATH = "res://Sprites/UI/ra_portrait.png"
export(Array, String) var NPC_DIALOGUE = ["Greetings, traveler",\
"Behold, that woven mat yonder, it possesses the power of flight. Step upon it, and it shall transport you to your inaugural trial",\
"Farewell, I have revealed all that is known, until we meet again"\
]

export(Array, String) var CONTINUE_DIALOGUE = [\
"You have passed the triels",
"Contuniue forth",\
"Farewell"\
]

export(bool) var CONTINUE_DIALOGUE_UNLOCKED = false

onready var name_label := $UI/AspectRatioContainer/Sprite/Portrait/NameLabel
onready var portrait := $UI/AspectRatioContainer/Sprite/Portrait
onready var text_label := $UI/AspectRatioContainer/Sprite/TextLabel
onready var animator := $AnimationPlayer
onready var sprite := $AnimatedSprite
onready var turn_timer := $TurnTimer

var is_showing_textbox = false
var player_in_range = false
var player: OverworldPlayer
var dialouge_index = 0

func _ready():
	portrait.texture = load(PORTRAIT_PATH)
	name_label.text = NAME

func _input(event):
	if player_in_range and event.is_action_released("ui_jump"):
		if is_showing_textbox:
			advance_dialouge()
		else:
			interact()
	
func interact():
	face_player()
	show_textbox()
	start_dialouge()
	
func start_dialouge():
	display_dialouge(dialouge_index)
	
func advance_dialouge():
	dialouge_index += 1
	if dialouge_index > NPC_DIALOGUE.size() - 1:
		hide_textbox()
		return
		
	display_dialouge(dialouge_index)
	
func display_dialouge(index: int):
	if CONTINUE_DIALOGUE_UNLOCKED:
		text_label.text = CONTINUE_DIALOGUE[index]
	else:
		text_label.text = NPC_DIALOGUE[dialouge_index]
	
func show_textbox():
	dialouge_index = 0
	is_showing_textbox = true
	animator.play("ShowTextBox")
	
func hide_textbox():
	dialouge_index = 0
	is_showing_textbox = false
	animator.play_backwards("ShowTextBox")
	
func face_player():
	var direction = (player.global_position - global_position).normalized()
	var angle = atan2(direction.y, direction.x)
	var rotation_degrees = rad2deg(angle)
	turn_timer.start()
	
	if abs(rotation_degrees) < 45:
		sprite.animation = "Right"
	elif abs(rotation_degrees) > 135:
		sprite.animation = "Left"
	elif rotation_degrees > 45 and rotation_degrees < 135:
		sprite.animation = "Down"
	else:
		sprite.animation = "Up"
	

func _on_InteractionZone_body_entered(body):
	if body is OverworldPlayer:
		player = body
	player_in_range = true

func _on_InteractionZone_body_exited(body):
	player_in_range = false
	if is_showing_textbox:
		hide_textbox()

func _on_TurnTimer_timeout():
	sprite.animation = "Down"
