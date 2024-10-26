extends Button
static var panelState: bool = false;
var panelAnimator: AnimationPlayer;
func _ready():
	panelAnimator = $"../../panels/animator"
	pressed.connect(clicked)
func clicked():
	panelState = !panelState
	panelAnimator.play("show" if panelState else "hide")
