extends CanvasLayer

@onready var animator: AnimationPlayer = $Animator

signal transition_start
signal transition_finished

func _ready() -> void:
	animator.connect("animation_finished", animation_finished)
func play_transition(transition_name: String, transition_speed : float = 1.0) -> void:
	animator.speed_scale = transition_speed
	animator.play(transition_name)
	transition_start.emit()
func animation_finished(anim_name : StringName) -> void:
	transition_finished.emit()
