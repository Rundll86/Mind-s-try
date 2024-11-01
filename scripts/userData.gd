extends Node;
class_name userData;
@export var startWeapons: Array[Weapon] = [];
@export var startWeaponIndex = 0;
static var items: Array[item] = [];
static var weapons: Array[Weapon] = [];
static var currentWeapon = 0;
static var lastWeaponIndex = -1;
static var player: entity;
static var subtanceSelf: Node;
static var showedTip: Array[int] = [];
func _ready():
	subtanceSelf = self
	weapons = startWeapons
	currentWeapon = startWeaponIndex
	player = $/root/world/player as entity
func _process(_delta: float):
	if is_instance_valid(player): player.weapons = weapons
static func next():
	currentWeapon += 1
	if currentWeapon >= len(weapons):
		currentWeapon = 0
	var lastAnimator = subtanceSelf.get_node_or_null("/root/world/ui-layer/ui-show/board/mamba-out/weapons/w" + str(lastWeaponIndex) + "/animator") as AnimationPlayer
	if lastAnimator: lastAnimator.play("in")
	var currentAnimator = subtanceSelf.get_node("/root/world/ui-layer/ui-show/board/mamba-out/weapons/w" + str(currentWeapon) + "/animator") as AnimationPlayer
	currentAnimator.play("out")
	lastWeaponIndex = currentWeapon
static func addWeapon(target: Weapon):
	weapons.append(target)
	init.createWeaponLabel(len(weapons) - 1)
