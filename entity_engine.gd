extends Node2D
var backScale = 0;
var backSpeed = 0.2;
var frontScale = 0;
var frontSpeed = 0.2;
func _process(_delta):
    backScale += backSpeed
    if backScale >= 3.0 or backScale <= 0.0:
        backSpeed *= -1
    frontScale += frontSpeed
    if frontScale >= 3 or frontScale <= 0.0:
        frontSpeed *= -1
    queue_redraw()
func _draw():
    draw_circle(Vector2.ZERO, 10.0 + backScale, Color("#b18145"))
    draw_circle(Vector2(0, -5), 5 + frontScale, Color("#b3b3b3"))