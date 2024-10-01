extends Node;
class_name userData;
@export var startWeapons: Array[weapon] = [];
@export var startWeaponIndex = 0;
static var items: Array[item] = [];
static var weapons: Array[weapon] = [];
static var currentWeapon = 0;
var lastWeaponIndex = -1;
var player: entity;
func _ready():
    weapons = startWeapons
    currentWeapon = startWeaponIndex
    player = $/root/world/player as entity
func _process(_delta):
    if lastWeaponIndex != currentWeapon:
        var lastAnimator = get_node_or_null("/root/world/camera/mamba-out/weapons/w" + str(lastWeaponIndex) + "/animator") as AnimationPlayer
        if lastAnimator: lastAnimator.play("in")
        var currentAnimator = get_node("/root/world/camera/mamba-out/weapons/w" + str(currentWeapon) + "/animator") as AnimationPlayer
        currentAnimator.play("out")
        lastWeaponIndex = currentWeapon
        player.weapons[2] = weapons[currentWeapon]