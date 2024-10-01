extends Button
var myAttrs: buff;
var player: entity;
func _ready():
    connect("pressed", pressed)
    myAttrs = $attrs
    player = $/root/world/player
func pressed():
    player.healthMax += myAttrs.healthMax
    player.attackSpeed += myAttrs.attackSpeed * 0.01
    player.attackDamage += myAttrs.attackDamage * 0.01
    player.moveSpeedBoost += myAttrs.movementSpeed * 0.01
    player.critRate += myAttrs.critRate * 0.01
    player.critDamageBoost += myAttrs.critDamage * 0.01
    player.evasion += myAttrs.evasion * 0.01
    get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("animator").play("hide")
    init.isSelectingBuff = false