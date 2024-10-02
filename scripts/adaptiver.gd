extends Control
class_name adaptiver
var sizeRatio: Vector2;
var positionRatio: Vector2;
@export var keepingSize: bool = false;
func _ready():
	sizeRatio = Vector2(
		size.x / ProjectSettings.get_setting("display/window/size/viewport_width"),
		size.y / ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	positionRatio = Vector2(
		position.x / ProjectSettings.get_setting("display/window/size/viewport_width"),
		position.y / ProjectSettings.get_setting("display/window/size/viewport_height")
	)
func _process(_delta):
	if not keepingSize: size = get_viewport_rect().size * sizeRatio
	position = get_viewport_rect().size * positionRatio