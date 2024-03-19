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

const KEY_SOUND = preload("res://Sound/FX/MISC/key_sound.wav")
const CROAK = preload("res://Sound/FX/MISC/croak.wav")
const POP = preload("res://Sound/FX/MISC/pop1.wav")
const ROAR = preload("res://Sound/FX/MISC/worm_roar.wav")
const TRUMPET = preload("res://Sound/FX/MISC/trumpet.wav")

# hypnosmna.com
const MUSIC_TRACKS = [
	preload("res://Sound/Music/Hypnos/Song01-The_Apocalypse_Under.wav"),
	preload("res://Sound/Music/Hypnos/Song02-Crimson City.wav"),
	preload("res://Sound/Music/Hypnos/Song03-Run!.wav"),
	preload("res://Sound/Music/Hypnos/Song04-Sky\'s Fall.wav"),
	preload("res://Sound/Music/Hypnos/Song05-Sail To Horizon.wav"),
	preload("res://Sound/Music/Hypnos/Song06-Dream Evolution.wav"),
	preload("res://Sound/Music/Hypnos/Song07-Drain The Night.wav"), 
	preload("res://Sound/Music/Hypnos/Song08-Time Nomad.wav"),
	preload("res://Sound/Music/Hypnos/Song09-Wasteland Night.wav"),
	preload("res://Sound/Music/Hypnos/Song10-The Beginning.wav")
]

# 8-bit hub https://the8bitsonghub.bandcamp.com/
const AFRICA = preload("res://Sound/Music/8-bitHub/The 8-Bit Song Hub - 8-Bit Toto-Africa.wav")
const AFRICA_SHORT = preload("res://Sound/Music/8-bitHub/Toto-Africa_radio_edition.wav")
const REAPER = preload("res://Sound/Music/8-bitHub/The 8-Bit Song Hub - 8-Bit Blue Oyster Cult-Don\'t Fear the Reaper.wav")

const CRITICAL_HIT = preload("res://Sound/Music/PixlCrushr/PixlCrushr - Ten! EP (Super Deluxe!)/PixlCrushr - Ten! EP (Super Deluxe!) - 02 Critical Hit!.wav")

# Naneek17
const CHIP_N_CHASE = preload("res://Sound/Music/Naneek17/Naneek17 - Chip N Chase.wav")
const OIL_OCEAN = preload("res://Sound/Music/Oil Ocean Zone.wav")

# Labbed @labbed.net
# All songs except remixes are licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License.
const SOURVIVOIRS_OF_THE_ASTREOID = preload("res://Sound/Music/Labbed/Labbed - Labhits 2016/Labbed - Labhits 2016 - 02 Survivors of the Asteroid.wav")
const PORT_SALUT = preload("res://Sound/Music/Labbed/Labbed - Labhits 2017/Labbed - Labhits 2017 - 01 Port Salut.wav")
const THE_SHOW_OFF = preload("res://Sound/Music/Labbed/Labbed - Labhits 2016/Labbed - Labhits 2016 - 04 The Show Off.wav")
const RAINDROPS_REFRACTIONS = preload("res://Sound/Music/Labbed/Labbed - Labhits 2013/Labbed - Labhits 2013 - 03 Raindrop Refraction.wav")
const FANTASY_VIOLENCE = preload("res://Sound/Music/Labbed/Labbed - Labhits 2014/Labbed - Labhits 2014 - 01 Fantasy Violence.wav")
const FIGHT_THE_EVIL = preload("res://Sound/Music/Labbed/Labbed - Labhits 2008/Labbed - Labhits 2008 - 01 Fight the Evil!.wav")
const VICTORI = preload("res://Sound/Music/Labbed/Labbed - Labhits 2008/Labbed - Labhits 2008 - 07 Viktori.wav")

func play_victori():
	play_music(VICTORI)
	
func play_africa():
	play_music(AFRICA_SHORT)
	
func play_reaper():
	play_music(REAPER)

const LEVEL_MUSIC = {
	1: FANTASY_VIOLENCE,
	2: FIGHT_THE_EVIL,
	3: SOURVIVOIRS_OF_THE_ASTREOID,
	4: RAINDROPS_REFRACTIONS,
	5: PORT_SALUT,
	99: null
}

const STONE_DOOR = preload("res://Sound/FX/MISC/stone_door.wav")

var music_playing = false
var current_level = 0

func start_music_for_level(index):
	if not LEVEL_MUSIC.has(index):
		stop_music()
		print("No music for this level")
		return
	if LEVEL_MUSIC[index] == null and not Events.check_point_reached:
		stop_music()
	if not music_playing and LEVEL_MUSIC.has(index) or (LEVEL_MUSIC.has(index) and current_level < index):
		current_level = index
		play_music(LEVEL_MUSIC[index])
		music_playing = true
	else:
		print("Invalid level index or music is already playing")
	
func stop_music():
	music_player.stop()
	music_playing = false

onready var audio_players: = $AudioPlayers
onready var music_player: = $MusicPlayer/AudioStreamPlayer

var audio_stream_players : Array = []

func _ready():
	audio_stream_players = audio_players.get_children()

func play_music(track):
	music_player.stream = track
	music_player.play()
	
func play_croak():
	play_sound(CROAK)
	
func play_pop():
	play_sound(POP)
	
func play_roar():
	play_sound(ROAR)
	
func play_trumpet():
	play_sound(TRUMPET)

func play_key_sound():
	play_sound(KEY_SOUND)
	
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

# Aphopis boss sounds
const APHOPIS_ENTRANCE = preload("res://Sound/FX/MISC/aphopis_entrance.wav")
const APHOPIS_HURT = preload("res://Sound/FX/MISC/aphopis_hurt.wav")
const APHOPIS_TELEGRAPH = preload("res://Sound/FX/MISC/aphopis_telegraph.wav")
const APHOPIS_DIE = preload("res://Sound/FX/MISC/aphopis_die.wav")
const LASER_SOUND = preload("res://Sound/FX/MISC/laser_sound.wav")
const APHOPIS_BITE = preload("res://Sound/FX/MISC/aphopis_bite.wav")

onready var laser_player := $LaserPlayer

func play_boss_music():
	play_music(MUSIC_TRACKS[3])
	
func play_laser_sound():
	laser_player.stream = LASER_SOUND
	laser_player.play()
	
func stop_laser_sound():
	laser_player.stop()
	
func play_aphopis_bite_sound():
	play_sound(APHOPIS_BITE)
	
func play_aphopis_entrance_sound():
	play_sound(APHOPIS_ENTRANCE)
	
func play_aphopis_die_sound():
	play_sound(APHOPIS_DIE)
	
func play_aphopis_hurt_sound():
	play_sound(APHOPIS_HURT)
	
func play_aphopis_telegraph_sound():
	play_sound(APHOPIS_TELEGRAPH)
