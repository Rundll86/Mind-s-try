extends Button
var myAttrs: buff;
var player: entity;
var myCard;
func _ready():
    connect("pressed", pressed)
    myAttrs = $attrs
    player = $/root/world/player
    myCard=get_parent().get_parent()
func pressed():
    player.healthMax += myAttrs.healthMax
    player.attackSpeed += myAttrs.attackSpeed * 0.01
    player.attackDamage += myAttrs.attackDamage * 0.01
    player.moveSpeedBoost += myAttrs.movementSpeed * 0.01
    player.critRate += myAttrs.critRate * 0.01
    player.critDamageBoost += myAttrs.critDamage * 0.01
    player.evasion += myAttrs.evasion * 0.01
    myCard.queue_free()