extends Node
class_name item
var itemID: String = "nothing";
var isSubstance: bool = true;
var player: entity;
func _ready():
	if isSubstance: return
	player = $/root/world/player
	print("dropped:" + itemID + "," + str($hitbox.disabled))
	if itemID == "coolant":
		player.coolant += player.coolantMax * 0.05
	elif itemID == "oil":
		player.oil += player.oilMax * 0.05
	else:
		init.inventory[itemID]["count"] += 1
	queue_free()
