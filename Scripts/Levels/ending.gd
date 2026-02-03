extends Node2D

@onready var animator: AnimationPlayer = $Animator

func fade_music() -> void:
	AudioManager.fade_music()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TransitionManager.play_transition("fade_enter")
	animator.connect("animation_finished", _on_finished)
func _on_finished(anim_name: StringName) -> void:
	TransitionManager.play_transition("fade_exit")
	await TransitionManager.transition_finished
	get_tree().change_scene_to_file("res://Scenes/Levels/menu.tscn")
