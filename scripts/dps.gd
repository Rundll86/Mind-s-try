extends VSlider;
var valueLabel: Label;
func _ready():
	valueLabel = $value
func _process(_delta):
	if init.isPlayerAlive:
		max_value += (init.playerEntity.weaponsDamage() / init.playerEntity.weaponsConsume() - max_value) * 0.3
		value += (damageNode.dps - value) * 0.3
		valueLabel.text = str(value)
