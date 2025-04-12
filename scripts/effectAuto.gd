extends GPUParticles2D;
class_name effectAuto;
@export var onWorld: bool = false;
@export var speed: float = 0;
@export var forwardInit: bool = false;
var startTime = 0;
var bullet: bulletAI;
@onready var initRotation: float = rotation_degrees;
func _ready():
	startTime = Time.get_ticks_msec()
	emitter()
func _process(_delta):
	position += Vector2.from_angle(deg_to_rad((initRotation if forwardInit else rotation_degrees) - 90)) * speed * 10
	queue_redraw()
	if isEnd():
		queue_free()
func _draw():
	drawer()
func livedTime():
	return Time.get_ticks_msec() - startTime
func emitter():
	emitting = true
func drawer():
	pass
func isEnd():
	return not emitting
func drawCheckedLines(points: Array[Vector2], splitor: Vector2, color: Color, width: float):
	for i in range(len(points) - 1):
		if points[i + 1] == splitor:
			continue
		draw_line(points[i], points[i + 1], color, width, true)
		draw_circle(points[i], width / 2, color)
		draw_circle(points[i + 1], width / 2, color)
func drawLaser(length: float, color: Color, width: float, invertColor: bool = false):
	var _color = func():
		draw_line(Vector2.ZERO, Vector2.UP * length, color, width * (2 if invertColor else 1), true)
		draw_circle(Vector2.ZERO, width * (1.0 if invertColor else 0.5), color)
		draw_circle(Vector2.UP * length, width * (1.0 if invertColor else 0.5), color)
	var _white = func():
		draw_line(Vector2.ZERO, Vector2.UP * length, Color(1, 1, 1, color.a), width * (1 if invertColor else 2), true)
		draw_circle(Vector2.ZERO, width * (0.5 if invertColor else 1.0), Color(1, 1, 1, color.a))
		draw_circle(Vector2.UP * length, width * (0.5 if invertColor else 1.0), Color(1, 1, 1, color.a))
	if invertColor:
		_color.call()
		_white.call()
	else:
		_white.call()
		_color.call()
func forceToEnd():
	emitting = false
