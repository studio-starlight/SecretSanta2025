extends Node2D

@export var transition : String = "fade"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	TransitionManager.play_transition(transition + "_enter")
	AudioManager.play_music(AudioManager.MUS_FOREST)
