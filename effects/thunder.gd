extends effectAuto;
@export var lineCount: int = 10;
func emitter():
    var lastPos = Vector2.ZERO
    for i in range(lineCount):
        var newPos = Vector2.from_angle(randf_range(0, 2 * PI)) * randf_range(50, 100)
        draw_line(lastPos, newPos, Color(1, 1, 1))
        lastPos = newPos