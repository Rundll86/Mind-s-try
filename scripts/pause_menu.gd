extends adaptiver
var tree;
func _ready():
    tree = get_tree()
func _process(_delta):
    visible = true
    if Input.is_action_just_released("unpause"):
        visible = false
        tree.paused = false