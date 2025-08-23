extends effectAuto;
class_name colorLaser;
var width = 1;
var direct = 1;
@export var length: float = 500;
@export var color: Color;
@export var toWidth = 20;
@export var alpha: float = 1;
@export var facingCursor:bool=false;
func drawer():
	if facingCursor:global_rotation=(get_global_mouse_position()-global_position).rotated(deg_to_rad(90)).angle()
	color.a = ((width - 1.0) / toWidth) * alpha
	drawLaser(length, color, width)
	width += direct
	if width > toWidth:
		direct = 0
func forceToEnd():
	direct = -1
	width = toWidth
func isEnd():
	return width < 1
func emitter():
	if bullet:
		var bulletHitbox = bullet.get_node("hitbox") as CollisionShape2D
		var bulletHitboxShape = bulletHitbox.shape as CapsuleShape2D
		bulletHitboxShape.radius = toWidth
		bulletHitboxShape.height = length
		bulletHitbox.position = Vector2(0, length / -2)
