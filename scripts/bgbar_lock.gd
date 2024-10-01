extends ProgressBar
var myParent;
func _ready():
    myParent = get_parent() as ProgressBar
func _process(_delta):
    size = myParent.size
    position = Vector2(0, 0)
    max_value = myParent.max_value
    value += (myParent.value - value) * (init.animationSpeed[1] if myParent.value < value else init.animationSpeed[0])