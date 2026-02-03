extends Node2D
@onready var main_menu: Control = $Canvas/MainMenu
@onready var play: Button = $Canvas/MainMenu/Margins/Buttons/Play
@onready var controls: Button = $Canvas/MainMenu/Margins/Buttons/Controls
@onready var quit: Button = $Canvas/MainMenu/Margins/Buttons/Quit
@onready var controls_menu: Control = $Canvas/ControlsMenu
@onready var back: Button = $Canvas/ControlsMenu/Margins/Back
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	AudioManager.play_sound(AudioManager.SOUND_FOREST)
	TransitionManager.play_transition("fade_enter")
	AudioManager.play_music(AudioManager.MUS_MENU)
	main_menu.visible = true
	controls_menu.visible = false
	play.connect("button_down", press_play)
	quit.connect("button_down", press_quit)
	controls.connect("button_down", press_controls)
	back.connect("button_down", press_back)
#============== BUTTONS =============================
func press_play() -> void:
	play.disabled = true
	controls.disabled = true
	quit.disabled = true
	TransitionManager.play_transition("fade_exit")
	await TransitionManager.transition_finished
	AudioManager.fade_music()
	get_tree().change_scene_to_file("res://Scenes/Levels/opening.tscn")
func press_controls() -> void:
	main_menu.visible = false
	controls_menu.visible = true
func press_quit() -> void:
	get_tree().quit()
func press_back() -> void:
	controls_menu.visible = false
	main_menu.visible = true
