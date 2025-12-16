extends StaticBody2D
@onready var animator: AnimationPlayer = $Animator
@onready var detection_area: Area2D = $DetectionArea
func _ready() -> void:
	detection_area.connect("body_entered", _on_detection)
func _on_detection(body : Node2D) -> void:
	if body is Player:
		animator.call_deferred("play", "spring")
		body.jump()
