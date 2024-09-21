extends Area2D
class_name item
var collectCount: int = 1;
var canBeCollect: bool = false;
var itemId: String = "item"
var player: entity;
func _ready():
    z_index = 1
    body_entered.connect(on_body_entered)
    player = $ / root / world / player
func on_body_entered(body):
    if not canBeCollect:
        return
    if body.name == "player":
        if itemId == "coolant":
            player.coolant += player.coolantMax * 0.15
        elif itemId == "oil":
            player.oil += player.oilMax * 0.05
        else: init.inventory[itemId]["count"] += collectCount
        queue_free()
