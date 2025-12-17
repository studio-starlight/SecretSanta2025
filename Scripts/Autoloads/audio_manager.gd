extends Node

@onready var sound_players : Array = $Sounds.get_children()

func play_sound(sound) -> void:
	for player : AudioStreamPlayer in sound_players:
		if !player.playing:
			player.stream = sound
			player.play()
			break
