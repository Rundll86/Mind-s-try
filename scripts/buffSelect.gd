extends Button
var myAttrs: buff;
var player: entity;
var myCard;
func _ready():
	connect("pressed", pressed)
	myAttrs = $attrs
	player = $/root/world/player
	myCard = get_parent().get_parent()
func pressed():
	var enoughCost = true;
	for i in myAttrs.costItems:
		if init.inventory[i.name]["count"] < myAttrs.costCounts[myAttrs.costItems.find(i)]:
			enoughCost = false;
			break
	if not enoughCost: return
	for i in myAttrs.costItems:
		init.inventory[i.name]["count"] -= myAttrs.costCounts[myAttrs.costItems.find(i)]
	player.healthMax += myAttrs.healthMax
	player.health += myAttrs.healthMax
	player.attackSpeed += myAttrs.attackSpeed * 0.01
	player.attackDamage += myAttrs.attackDamage * 0.01
	player.moveSpeedBoost += myAttrs.movementSpeed * 0.01
	player.critRate += myAttrs.critRate * 0.01
	player.critDamageBoost += myAttrs.critDamage * 0.01
	player.evasion += myAttrs.evasion * 0.01
	player.coolantMax += myAttrs.coolant
	player.coolant += myAttrs.coolant
	player.slagMax += myAttrs.slag
	player.slag += myAttrs.slag
	player.oilMax += myAttrs.oil
	player.oil += myAttrs.oil
	if myAttrs.addWeapon:
		userData.addWeapon(myAttrs.addWeapon)
		player.currentWeaponIndex += 1
	player.haveBuffCount += 1
	myCard.queue_free()
