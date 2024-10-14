extends Button
var tree;
func _ready():
    tree = get_tree()
    pressed.connect(onPressed)
func onPressed():
    tree.paused = false
    panelDefine.closeCurrent()