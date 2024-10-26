extends effectAuto;
class_name parallax;
var width = 1;
var toWidth = 20;
var direct = 1;
@export var length:float=500;
@export var color: Color;
func drawer():
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
		var bulletHitbox=bullet.get_node("hitbox") as CollisionShape2D
		var bulletHitboxShape=bulletHitbox.shape as CapsuleShape2D
		bulletHitboxShape.radius = toWidth
		bulletHitboxShape.height = length
		bulletHitbox.position = Vector2(0, length/-2)
