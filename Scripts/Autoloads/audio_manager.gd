extends Node

@onready var sound_players : Array = $Sounds.get_children()
@onready var music_player : AudioStreamPlayer = $Music/AudioStreamPlayer
@onready var animator: AnimationPlayer = $Music/Animator
const SOUND_AIM = preload("uid://btra1et6xtpbx")
const SOUND_FOOTSTEP = preload("uid://ry7c82kxyrnv")
const SOUND_HURT = preload("uid://bdbnoj4mypvd7")
const SOUND_JUMP = preload("uid://di5qvy42eph47")
const SOUND_LAND = preload("uid://cxfe4s77eh3vj")
const SOUND_ORB = preload("uid://3fogfvncmnkw")
const SOUND_THROW = preload("uid://cedkurj3ohtda")
const SOUND_THUD = preload("uid://w5e2v766mj0t")
const SOUND_FOREST = preload("res://Audio/Sounds/sound_forest.ogg")
const MUS_MENU = preload("uid://dgnwgpyf0ggok")
const MUS_FOREST = preload("uid://cna0140vyr6gs")

func play_sound(sound) -> void:
	for player : AudioStreamPlayer in sound_players:
		if !player.playing:
			player.stream = sound
			player.play()
			break
func play_music(music) -> void:
	if !music_player.playing:
		music_player.stream = music
		music_player.play()
func fade_music() -> void:
	animator.play("fade")
	await animator.animation_finished
	music_player.stop()
	animator.play("RESET")
