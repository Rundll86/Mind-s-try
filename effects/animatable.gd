extends effectAuto
@export var animators:Array[AnimationPlayer];
@export var animationNames:Array[String]=[];
func emitter():
	for i in range(len(animators)):
		animators[i].play(animationNames[i])
func isEnd():
	var result=true
	for i in animators:
		if i.is_playing():
			result=false
			break
	return result
