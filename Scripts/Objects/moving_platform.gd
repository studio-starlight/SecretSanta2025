extends Path2D

enum animation_type{pong, loop}

@export var type : animation_type
@export var speed : float = 1.0

@onready var animator: AnimationPlayer = $Animator

func _ready() -> void:
	animator.speed_scale = speed
	match type:
		animation_type.pong:
			animator.play("pong")
		animation_type.loop:
			animator.play("loop")
