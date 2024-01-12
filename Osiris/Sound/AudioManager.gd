extends Node

const JUMP_SOUNDS = [
	preload("res://Sound/FX/Jump/Jump1.wav"),
	preload("res://Sound/FX/Jump/Jump2.wav"),
	preload("res://Sound/FX/Jump/Jump3.wav"),
	preload("res://Sound/FX/Jump/Jump4.wav"),
	preload("res://Sound/FX/Jump/Jump5.wav")
]

const HIT_SOUNDS = [
	preload("res://Sound/FX/Hurt/Hit_Hurt1.wav"),
	preload("res://Sound/FX/Hurt/Hit_Hurt2.wav"),
	preload("res://Sound/FX/Hurt/Hit_Hurt3.wav"),
	preload("res://Sound/FX/Hurt/Hit_Hurt4.wav"),
	preload("res://Sound/FX/Hurt/Hit_Hurt5.wav")
]

const CHECKPOINT_SOUNDS = [
	preload("res://Sound/FX/Checkpoint/Powerup1.wav")
]

const DIE_SOUND = [
	#preload("res://Sound/FX/Die/Explosion.wav"),
	preload("res://Sound/FX/Die/Explosion1.wav")
]

const EXPLOSION_SOUNDS = [
	preload("res://Sound/FX/Hurt/Explosion.wav"),
	preload("res://Sound/FX/Die/Explosion1.wav")
]

const MUSIC_TRACKS = [
	preload("res://Sound/Music/Song01-The_Apocalypse_Under.wav"),
	preload("res://Sound/Music/Song02-Crimson City.wav"),
	preload("res://Sound/Music/Song03-Run!.wav"),
	preload("res://Sound/Music/Song04-Sky\'s Fall.wav"),
	preload("res://Sound/Music/Song05-Sail To Horizon.wav"),
	preload("res://Sound/Music/Song06-Dream Evolution.wav"),
	preload("res://Sound/Music/Song07-Drain The Night.wav"), 
	preload("res://Sound/Music/Song08-Time Nomad.wav"),
	preload("res://Sound/Music/Song09-Wasteland Night.wav"),
	preload("res://Sound/Music/Song10-The Beginning.wav")
]

const STONE_DOOR = preload("res://Sound/FX/MISC/stone_door.wav")

const APHOPIS_ENTRANCE = preload("res://Sound/FX/MISC/aphopis_entrance.wav")

onready var audio_players: = $AudioPlayers
onready var music_player: = $MusicPlayer/AudioStreamPlayer

var audio_stream_players : Array = []

func _ready():
	#play_music(1)
	audio_stream_players = audio_players.get_children()

func play_music(level):
	print(MUSIC_TRACKS[level - 1])
	music_player.stream = MUSIC_TRACKS[level - 1]
	music_player.play()
	
func play_aphopis_entrance_sound():
	play_sound(APHOPIS_ENTRANCE)

func play_random_explosion_sound():
	play_random_sound(EXPLOSION_SOUNDS)
	
func play_random_checkpoint_sound():
	play_random_sound(CHECKPOINT_SOUNDS)
	
func play_random_die_sound():
	play_random_sound(DIE_SOUND)
	
func play_random_jump_sound():
	play_random_sound(JUMP_SOUNDS)
	
func play_random_hit_sound():
	play_random_sound(HIT_SOUNDS)
	
func play_stone_door_sound():
	play_sound(STONE_DOOR)

func play_random_sound(sounds):
	if sounds.size() > 0:
		var random_index = randi() % sounds.size()
		play_sound(sounds[random_index])
			
func play_sound(sound):
	for audio_stream_player in audio_stream_players:
		if not audio_stream_player.playing:
			audio_stream_player.stream = sound
			audio_stream_player.play()
			break
