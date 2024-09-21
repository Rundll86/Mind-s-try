extends Camera2D
@export var target: Node2D
func _process(_delta: float) -> void:
	if not target: return
	position = target.position
