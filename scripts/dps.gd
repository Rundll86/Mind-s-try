extends VSlider;
class_name dpsCurrent;
var valueLabel: Label;
static var targetDps: float = 0;
func _ready():
	valueLabel = $value
func _process(_delta):
	if init.isPlayerAlive:
		max_value += (init.playerEntity.weaponsDamage() / init.playerEntity.weaponsConsume() - max_value) * 0.3
		value += (targetDps - value) * 0.3
		valueLabel.text = str(value)
