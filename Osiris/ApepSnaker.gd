extends Path2D

const HISS := preload("res://Sound/FX/MISC/snake_hiss.wav")

export var active = false

const SPEED = 0.025

onready var snake = [
	$SnakePart_2, 
	$SnakePart_1, 
	$SnakeHead, 
	$SnakePart, 
	$SnakePart2, 
	$SnakePart3, 
	$SnakePart4, 
	$SnakePart5, 
	$SnakePart6, 
	$SnakePart7, 
	$SnakePart8, 
	$SnakePart9, 
	$SnakePart10, 
	$SnakePart11, 
	$SnakePart12, 
	$SnakePart13, 
	$SnakeTail, 
	$SnakePart14
]

var initial_offsets = []

func _ready():
	for part in snake:
		initial_offsets.append(part.unit_offset)

func _physics_process(delta):
	if active:
		for part in snake:
			var offset = fmod(part.unit_offset + SPEED * delta, 1.0)
			(part as PathFollow2D).set_deferred("unit_offset", offset)

func reset():
	active = false
	
	for i in range(snake.size()):
		snake[i].unit_offset = initial_offsets[i]

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()

func _on_VisibilityNotifier2D_screen_entered():
	AudioManager.play_sound(HISS)
