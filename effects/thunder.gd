extends effectAuto;
var points:Array[Vector2]=[];
var width=1;
var toWidth=5;
var direct=1;
var lineCount:int=8;
var angleOffsetEveryLine:float=45;
@export var color:Color;
func emitter():
	var lastAngle=180
	for j in range(randi_range(2,4)):
		points.append(Vector2.ZERO)
		for i in range(lineCount):
			var currentLength=randf_range(40,75)
			var currentAngle=deg_to_rad(
					lastAngle+randf_range(
						-angleOffsetEveryLine,
						angleOffsetEveryLine
					)
				)
			var calcx=points[len(points)-1].x+currentLength*sin(currentAngle)
			var calcy=points[len(points)-1].y+currentLength*cos(currentAngle)
			if bullet:
				var currentHitbox=CollisionShape2D.new()
				var currentShape=SegmentShape2D.new()
				currentShape.a=points[len(points)-1]
				currentShape.b=Vector2(calcx,calcy)
				currentHitbox.shape=currentShape
				bullet.add_child(currentHitbox)
			points.append(Vector2(calcx,calcy))
func drawer():
	drawCheckedLines(points,Vector2.ZERO,Color(1,1,1,(width-1.0)/toWidth),width*2)
	color.a=(width-1.0)/toWidth
	drawCheckedLines(points,Vector2.ZERO,color,width)
	width+=direct
	if width>toWidth:
		direct=-1
func isEnd():
	return width<=0
