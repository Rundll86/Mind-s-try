extends VSlider;
var valueLabel: Label;
func _ready():
    valueLabel = $value
func _process(_delta):
    if init.isPlayerAlive:
        max_value += (dpsCurrent.targetDps - max_value) * 0.3
        value += (init.playerEntity.weaponsDamage() / init.playerEntity.weaponsConsume() - value) * 0.3
        valueLabel.text = str(value)