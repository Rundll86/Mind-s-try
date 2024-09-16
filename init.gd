extends Node2D
func _ready():
    $projectiles.hide()
    $units.hide()
    generateUnit("stell", Vector2(0, 0))
func generateUnit(target: String, pos: Vector2):
    var unit = get_node("units/" + target).duplicate() as entity
    unit.position = pos
    unit.enableAi = true
    add_child(unit)