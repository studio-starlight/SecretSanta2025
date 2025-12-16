class_name RoomArea extends Area2D

@export var respawn_point : Node2D
@onready var respawn_position = respawn_point.global_position
@onready var camera : ModifiedCamera = get_tree().get_first_node_in_group("camera")
func _ready() -> void:
	connect("body_entered", _on_room_entered)
	connect("body_exited", _on_room_exited)
func _on_room_entered(body : Node2D) -> void:
	if body is Player:
		body.set_room(self)
		camera.room_zones.append(self)
func _on_room_exited(body: Node2D) -> void:
	if body is Player:
		camera.room_zones.erase(self)
