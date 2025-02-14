extends Node

var start_volmue
var fade_out_speed = 5  # Adjust this to control the speed of the fade-out
var fading_out = false
var fading_in = false

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

# Original Songs
const SHADOW_OF_THE_SPHINX = preload("res://Sound/Music/Original/Shadow of the sphinx.wav")
const FOLLOW_THE_OTTERS = preload("res://Sound/Music/Original/Follow the otters.wav")
const LOTUS_BEACH = preload("res://Sound/Music/Original/Lotus Beach.wav")
const CROCODILE_TEARS = preload("res://Sound/Music/Original/Crocodile Tears.wav")
const KING_IN_YELLOW = preload("res://Sound/Music/Original/King in Yellow.wav")
const LIGHTBRINGER = preload("res://Sound/Music/Original/Lightbringer.wav")
const SOLAR_FLARE = preload("res://Sound/Music/Original/Solar Flare.wav")
const SWING_FIELDS = preload("res://Sound/Music/Original/Swing Fields.wav")
const UNDERGROUND_SUMMER = preload("res://Sound/Music/Original/Underground Summer.wav")
const APOPHIS_ARISING = preload("res://Sound/Music/Original/Apophis Arising.wav")
const SETIS_OATH = preload("res://Sound/Music/Original/Setis Oath.wav")
const DESERT_OCTOPUS = preload("res://Sound/Music/Original/Deflemask/DesertOctuopus.wav")
const DREAM_OFF = preload("res://Sound/Music/Original/Deflemask/DreamOff.wav")
const PYRAMID_FUNK = preload("res://Sound/Music/Original/Deflemask/PyramidFunk.wav")

func play_victori():
	play_music(VICTORI)
	
func play_africa():
	play_music(AFRICA_SHORT)
	
func play_reaper():
	play_music(REAPER)
	
func play_overworld_music():
	play_music(PYRAMID_FUNK)

const LEVEL_MUSIC = {
	0: CROCODILE_TEARS,
	1: KING_IN_YELLOW,
	2: SOLAR_FLARE,
	3: LIGHTBRINGER,
	4: LOTUS_BEACH,
	5: SWING_FIELDS,
	99: null
}

const STONE_DOOR = preload("res://Sound/FX/MISC/stone_door.wav")

var music_playing = false
var current_level = 0

var current_song = null

func start_level_music(song):
	if song == null and not Events.check_point_reached:
		stop_music()
		music_playing = false
		current_song = null
	elif not music_playing or current_song != song:
		play_music(song)
		music_playing = true
		current_song = song

func start_music_for_level(index):
	if not LEVEL_MUSIC.has(index):
		stop_music()
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

func fade_music():
	fading_out = true
	fading_in = false
	music_playing = false

func fade_in_music(song):
	play_music(song)
	music_player.volume_db = -10
	fading_in = true
	fading_out = false
	music_playing = true

onready var audio_players: = $AudioPlayers
onready var music_player: = $MusicPlayer/AudioStreamPlayer

var audio_stream_players : Array = []

func _ready():
	start_volmue = music_player.volume_db
	audio_stream_players = audio_players.get_children()
	
func play_music(track):
	fading_out = false
	music_player.volume_db = start_volmue
	music_player.stream = track
	music_player.play()
	
func play_seti_music():
	play_music(SETIS_OATH)
	
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

# Seti sounds
const SETI_ENTRANCE = preload("res://Sound/FX/Seti/seti_entrance.wav")
const SETI_HURT = preload("res://Sound/FX/Seti/seti_hurt.wav")
const SETI_DIE = preload("res://Sound/FX/Seti/seti_die.wav")
const SETI_TELEGRAPH = preload("res://Sound/FX/Seti/seti_telegraph.wav")
const SETI_TELE_JUMP = preload("res://Sound/FX/Seti/seti_tel_jump.wav")
const SETI_TORNADO = preload("res://Sound/FX/Seti/seti_tornado.wav")

const SWOOSH = preload("res://Sound/FX/Seti/swoosh.wav")
const TELEPORT = preload("res://Sound/FX/Seti/teleport.wav")
const BOOM = preload("res://Sound/FX/Seti/boom.wav")
const BATS = preload("res://Sound/FX/Seti/seti_bats.wav")
const BAT_SWARM = preload("res://Sound/FX/Seti/bat_swarm.wav")
const FANFARE = preload("res://Sound/Music/Original/Fanfare.wav")
const FART1 = preload("res://Sound/FX/MISC/fart1.wav")
const FART2 = preload("res://Sound/FX/MISC/fart2.wav")
const FART3 = preload("res://Sound/FX/MISC/fart3.wav")
const LEO_FIRE = preload("res://Sound/FX/MISC/leo_fire.wav")
const CLICK = preload("res://Sound/FX/MISC/klick.wav")
const FLAME = preload("res://Sound/FX/MISC/flame.wav")
const POWER_UP = preload("res://Sound/FX/MISC/power_up.wav")
const SHOT1 = preload("res://Sound/FX/MISC/shot1.wav")
const SHOT2 = preload("res://Sound/FX/MISC/shot2.wav")
const SHOT3 = preload("res://Sound/FX/MISC/shot3.wav")
const BREAK = preload("res://Sound/FX/MISC/break.wav")

onready var laser_player := $LaserPlayer

func play_break():
	play_sound(BREAK)
	
func play_random_shot():
	play_random_sound([ SHOT1, SHOT2, SHOT3 ])
	
func play_power_up():
	play_sound(POWER_UP)

func play_flame():
	play_sound(FLAME)
	
func play_click():
	play_sound(CLICK)
	
func play_leo_fire():
	play_sound(LEO_FIRE)
	
func play_random_fart():
	play_random_sound([ FART1, FART2, FART3 ])
	
const COW_MOO = preload("res://Sound/FX/MISC/robot_cow_moo.wav")
const COW_ATTACK = preload("res://Sound/FX/MISC/robot_cow_attack.wav")
const COW_DIE = preload("res://Sound/FX/MISC/robot_cow_die.wav")
const COW_THRUST = preload("res://Sound/FX/MISC/robot_cow_thrust.wav")

func play_cow_moo():
	play_sound(COW_MOO)

func play_cow_thrust():
	play_sound(COW_THRUST)
	
func play_cow_die():
	play_sound(COW_DIE)

func play_cow_attck():
	play_sound(COW_ATTACK)
	
func play_fanfare():
	play_sound(FANFARE)

func play_bat_swarm():
	play_sound(BAT_SWARM)

const BENNUS_CRAVING = preload("res://Sound/Music/Original/Deflemask/Bennu´s Craving.wav")
const BENNU_WAKE_UP = preload("res://Sound/FX/MISC/bennu_wake_up.wav")
const BENNU_HURT = preload("res://Sound/FX/MISC/bennu_hurt.wav")
const BENNU_ATTACK = preload("res://Sound/FX/MISC/bennu_attack.wav")
const BENNU_ATTACK_2 = preload("res://Sound/FX/MISC/bennu_attack_2.wav")
const ELECTRIC_CHARGE = preload("res://Sound/FX/MISC/electric_charge.wav")
const BENNU_SHOOT = preload("res://Sound/FX/MISC/bennu_shoot.wav")

func play_bennu_music():
	play_music(BENNUS_CRAVING)

func play_bennu_shoot():
	play_sound(BENNU_SHOOT)

func play_electric_charge():
	play_sound(ELECTRIC_CHARGE)

func play_bennu_attack():
	play_random_sound([ BENNU_ATTACK, BENNU_ATTACK_2])

func play_bennu_wake_up():
	play_sound(BENNU_WAKE_UP)
	
func play_bennu_hurt():
	play_sound(BENNU_HURT)

func play_bat_sound():
	play_sound(BATS)
	
func play_seti_tronado():
	play_sound(SETI_TORNADO)
	
func play_boom():
	play_sound(BOOM)
	
func play_seti_tele_jump():
	play_sound(SETI_TELE_JUMP)
	
func play_teleport():
	play_sound(TELEPORT)
	
func play_swoosh():
	play_sound(SWOOSH)
	
func play_set_entrance():
	play_sound(SETI_ENTRANCE)
	
func play_seti_hurt():
	play_sound(SETI_HURT)
	
func play_seti_telegraph():
	play_sound(SETI_TELEGRAPH)
	
func play_seti_die():
	play_sound(SETI_DIE)

func play_boss_music():
	play_music(APOPHIS_ARISING)
	
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
	
func _process(delta):
	if fading_out:
		music_player.volume_db -= fade_out_speed * delta
		if music_player.volume_db <= -80:  # Volume is effectively off at -80 dB
			music_player.stop()
			music_player.volume_db = start_volmue
			fading_out = false
	if fading_in:
		music_player.volume_db += fade_out_speed * delta
		if music_player.volume_db >= start_volmue:
			music_player.volume_db = start_volmue
			fading_in = false

const TERROR_BIRD_ALERT = preload("res://Sound/FX/MISC/terror_bird_alert.wav")
const TERROR_BIRD_HURT = preload("res://Sound/FX/MISC/terror_bird_hurt.wav")
const TERROR_BIRD_DIE = preload("res://Sound/FX/MISC/terror_bird_die.wav")

func play_terror_bird_alert():
	play_sound(TERROR_BIRD_ALERT)

func play_terror_bird_hurt():
	play_sound(TERROR_BIRD_HURT)
	
func play_terror_bird_die():
	play_sound(TERROR_BIRD_DIE)

const RUMBLE = preload("res://Sound/FX/MISC/8-bit-rumbling.wav")
const LOW_RUMBLE = preload("res://Sound/FX/MISC/low_rumbling.wav")
const HOR_EM_SCREAM = preload("res://Sound/FX/MISC/Hor_Em_Akhet_scream.wav")

func play_rumble():
	play_sound(RUMBLE)
	
func play_low_rumble():
	play_sound(LOW_RUMBLE)

func play_hor_em_scream():
	play_sound(HOR_EM_SCREAM)
	
const SIC_SEMPER_TYRANNIS := preload("res://Sound/Music/Original/Deflemask/SicSemperTyrannis.wav")
const THUNDER_1 := preload("res://Sound/FX/MISC/thunder_clap_1.wav")
const THUNDER_2 := preload("res://Sound/FX/MISC/thunder_clap_2.wav")
const THUNDER_3 := preload("res://Sound/FX/MISC/thunder_clap_3.wav")
const Thunder_4 := preload("res://Sound/FX/MISC/thunder_clap_4.wav")
const ORGASMS := preload("res://Sound/Music/Original/Deflemask/MultipleOrgasmIntoTheFlames.wav")

func play_sec_semper():
	play_music(SIC_SEMPER_TYRANNIS)

func play_orgasms():
	play_music(ORGASMS)
	
func play_random_thunder():
	play_random_sound([ THUNDER_1, THUNDER_2, THUNDER_3, Thunder_4 ])
	
func play_main_theme():
	if music_player.is_playing() and music_player.stream == ORGASMS:
		pass
	else:
		play_music(ORGASMS)

const FALL_OF_RA = preload("res://Sound/Music/Original/Deflemask/FallOfRa.wav")
const RA_CHANT1 := preload("res://Sound/FX/MISC/Ra_chant1.wav")
const RA_CHANT2 := preload("res://Sound/FX/MISC/Ra_chant2.wav")
const RA_CHANT3 := preload("res://Sound/FX/MISC/Ra_chant3.wav")
const RA_HURT := preload("res://Sound/FX/MISC/ra_hurt.wav")

func play_ra_chant1():
	play_sound(RA_CHANT1)
	
func play_ra_chant2():
	play_sound(RA_CHANT2)
	
func play_ra_chant3():
	play_sound(RA_CHANT3)

func play_ra_hurt():
	play_sound(RA_HURT)

func play_ra_music():
	play_music(FALL_OF_RA)
	
const LAVA_DRIP := preload("res://Sound/FX/MISC/lava_drip.wav")
const LAVA_DROP := preload("res://Sound/FX/MISC/lava_drop.wav")

func play_lava_drip():
	play_sound(LAVA_DRIP)

func play_lava_drop():
	play_sound(LAVA_DROP)

const FORCED_PLEASURE := preload("res://Sound/Music/Original/Deflemask/ForcedPleasure.wav")

func play_forced_pleasure():
	play_music(FORCED_PLEASURE)

const DING := preload("res://Sound/FX/MISC/ding_1.wav")

const BAHT_MOAN_1 := preload("res://Sound/FX/MISC/Baht_moan_1.wav")
const BAHT_MOAN_2 := preload("res://Sound/FX/MISC/Baht_moan_2.wav")
const BAHT_MOAN_3 := preload("res://Sound/FX/MISC/Baht_moan_3.wav")
const BAHT_MOAN_4 := preload("res://Sound/FX/MISC/Baht_moan_4.wav")

const BAHT_SUCK := preload("res://Sound/FX/MISC/Baht_suck.wav")
const BAHT_FIRE := preload("res://Sound/FX/MISC/Baht_moan_fire.wav")

func play_ding():
	play_sound(DING)

func play_random_baht_moan():
	play_random_sound([BAHT_MOAN_1, BAHT_MOAN_2, BAHT_MOAN_3, BAHT_MOAN_4])

func play_baht_die():
	play_sound(BAHT_MOAN_4)

func play_baht_suck():
	play_sound(BAHT_SUCK)
	
func play_baht_fire():
	play_sound(BAHT_FIRE)

const PARO_MUSIC = preload("res://Sound/Music/Original/Deflemask/DirtySecretsOfEasterIsland.wav")

func play_paro_music():
	play_music(PARO_MUSIC)
