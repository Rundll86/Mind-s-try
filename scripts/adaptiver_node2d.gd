extends Node2D
var positionRatio;
func _ready():
    var parent = get_parent()
    if parent and parent is Control:
        positionRatio = position / parent.size
    else:
        queue_free()
func _process(_delta):
    position = positionRatio * get_parent().size