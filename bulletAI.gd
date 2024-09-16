extends Area2D
class_name bulletAI
@export var speed = 1
@export var enable = false
func _process(_delta):
	if not enable:
		return
	position += Vector2.from_angle(deg_to_rad(global_rotation_degrees - 90)) * speed * 10