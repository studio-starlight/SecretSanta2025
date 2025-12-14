extends StaticBody2D
@onready var detect_area: Area2D = $DetectArea
@onready var animator: AnimationPlayer = $Animator

func _ready() -> void:
	detect_area.connect("body_entered", _on_detect)
func _on_detect(body : Node2D) -> void:
	if body is Player:
		animator.call_deferred("play", "fall")
