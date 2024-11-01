extends Node
class_name item
var itemID: String = "nothing";
var isSubstance: bool = true;
var player: entity;
func _ready():
	if isSubstance: return
	player = get_node_or_null("/root/world/player")
	if not is_instance_valid(player):
		return
	print("dropped:" + itemID + "," + str($hitbox.disabled))
	if itemID == "coolant":
		player.coolant += player.coolantMax * 0.05
	elif itemID == "oil":
		player.oil += player.oilMax * 0.05
	else:
		init.inventory[itemID]["count"] += 1
	queue_free()
