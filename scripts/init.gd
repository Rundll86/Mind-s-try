extends Node2D;
class_name init;
static var isPlayerAlive: bool = true;
static var inventory = {};
static var animationSpeed = [0.7, 0.01];
static var wave:int = 0;
static var staticFuncCaller;
static var readWaves: Array[waveDefine] = [];
static var isSelectingBuff: bool = false;
static var enemyCount = 0;
static var resetBuffCostSaved: int = 0;
static var playerEntity: entity;
static var weaponExample: HBoxContainer;
static var weaponShow;
static var itemLabelExmaple: itemLabel;
static var json = JSON.new();
static var entriesContainer: VBoxContainer;
var bossBar: valuebar;
var bossAvatar: TextureRect;
var bossName: Label;
var bossValue: Label;
var waveTip;
var buffsShow;
var buffCardExample;
var buffCostCardExample;
@export var initWave: int = 1;
@export var initItems: Array[item] = [];
@export var initItemCounts: Array[int] = [];
@export var resetBuffCost: int = 30;
@export var loadSave: bool = true;
func _ready():
	$"ui-layer".show()
	resetBuffCostSaved = resetBuffCost
	$projectiles.hide()
	$units.hide()
	$items.hide()
	$effects.hide()
	for i in $buffs.get_children():
		buff.collections.append(i)
	waveTip = $"ui-layer/ui-show/panels/bg/waveTip"
	wave = initWave - 1
	buffsShow = waveTip.get_node("bar/buffs")
	buffCostCardExample = buffsShow.get_node("example/content/costs/example")
	buffCostCardExample.get_parent().remove_child(buffCostCardExample)
	buffCardExample = buffsShow.get_node("example")
	buffCardExample.get_parent().remove_child(buffCardExample)
	bossBar = $"ui-layer/ui-show/board/bossHealth"
	bossAvatar = bossBar.get_node("transformer/avatar")
	bossName = bossAvatar.get_node("name")
	bossValue = bossBar.get_node("transformer/value")
	weaponShow = $"ui-layer/ui-show/board/mamba-out/weapons"
	weaponExample = weaponShow.get_node("w0")
	weaponExample.get_parent().remove_child(weaponExample)
	entriesContainer = $"ui-layer/ui-show/board/infos/damage/cont/panels/entries/container"
	for i in range(len(userData.weapons)):
		createWeaponLabel(i)
	for i in $waves.get_children():
		readWaves.append(i)
	staticFuncCaller = self
	itemLabelExmaple = $"ui-layer/ui-show/board/infos/damage/cont/panels/items/container/example"
	itemLabelExmaple.get_parent().remove_child(itemLabelExmaple)
	for i in $items.get_children():
		if i.name in ["coolant", "oil"]:
			continue
		var currentLabel = itemLabelExmaple.duplicate() as itemLabel
		currentLabel.itemTexture = i.get_node("texture").texture
		inventory[i.name] = {
			"count": 0,
			"label": currentLabel
		}
		$"ui-layer/ui-show/board/infos/damage/cont/panels/items/container".add_child(currentLabel)
	for i in range(len(initItems)):
		inventory[initItems[i].name]["count"] += initItemCounts[i]
	playerEntity = $/root/world/player
	if loadSave: save.loadData()
func _process(_delta):
	waveTip.get_node("bar/tools/cost").text = str(resetBuffCostSaved)
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		panelDefine.checkTo("pause")
	for i in inventory.values():
		i["label"].count = str(i["count"])
	if isPlayerAlive:
		entriesContainer.get_node("healthMax").entryValue = playerEntity.healthMax
		entriesContainer.get_node("shootOffset").entryValue = playerEntity.shootOffset
		entriesContainer.get_node("critRate").entryValue = playerEntity.critRate
		entriesContainer.get_node("critDamage").entryValue = playerEntity.critDamageBoost
		entriesContainer.get_node("evasion").entryValue = playerEntity.evasion
		entriesContainer.get_node("attackSpeed").entryValue = playerEntity.attackSpeed
		entriesContainer.get_node("attackDamage").entryValue = playerEntity.attackDamage
		entriesContainer.get_node("movementSpeed").entryValue = playerEntity.moveSpeedBoost + 1
		enemyCount = 0
		for i in get_children():
			if i.name.begins_with("enemy_"):
				enemyCount += 1
		if enemyCount == 0 and not isSelectingBuff:
			panelDefine.checkTo("waveTip")
	var currentBoss = findBoss()
	bossBar.visible = currentBoss != null
	if currentBoss:
		bossBar.maxValue = currentBoss.healthMax
		bossBar.currentValue = currentBoss.health
		bossAvatar.texture = currentBoss.texture.texture
		bossName.text = currentBoss.displayName
		bossValue.text = str(int(currentBoss.health)) + "/" + str(int(currentBoss.healthMax))
static func generateBuffCard():
	for i in staticFuncCaller.buffsShow.get_children():
		if i.name != "animator": staticFuncCaller.buffsShow.remove_child(i)
	buff.collections.shuffle()
	for i in buff.collections.slice(0, 3):
		var entries = ""
		if i.healthMax > 0:
			entries += "生命上限+" + str(i.healthMax) + "点\n"
		if i.attackSpeed > 0:
			entries += "武器重载效率+" + str(i.attackSpeed) + "%\n"
		if i.attackDamage > 0:
			entries += "伤害+" + str(i.attackDamage) + "%\n"
		if i.movementSpeed > 0:
			entries += "引擎功率+" + str(i.movementSpeed) + "%\n"
		if i.critRate > 0:
			entries += "暴击率+" + str(i.critRate) + "%\n"
		if i.critDamage > 0:
			entries += "暴击伤害+" + str(i.critDamage) + "%\n"
		if i.evasion > 0:
			entries += "闪避率+" + str(i.evasion) + "%\n"
		if i.coolant > 0:
			entries += "冷却液上限+" + str(i.coolant) + "FS\n"
		if i.oil > 0:
			entries += "芳油上限+" + str(i.oil) + "FS\n"
		if i.slag > 0:
			entries += "矿渣上限+" + str(i.slag) + "FS\n"
		if i.addWeapon:
			entries += "获得武器：" + i.addWeapon.displayName + "\n"
		var currentBuff = staticFuncCaller.buffCardExample.duplicate()
		currentBuff.get_node("content/name").text = i.displayName
		currentBuff.get_node("content/texture").texture = i.texture
		currentBuff.get_node("content/entry").text = entries;
		var clonedI = i.duplicate() as buff
		clonedI.name = "attrs"
		var currentSelectButton = currentBuff.get_node("content/select")
		currentSelectButton.remove_child(currentSelectButton.get_node("attrs"))
		currentSelectButton.add_child(clonedI)
		for j in i.costItems:
			var currentCost = staticFuncCaller.buffCostCardExample.duplicate()
			currentCost.get_node("avatar").texture = j.get_node("texture").texture
			currentCost.get_node("count").text = str(i.costCounts[i.costItems.find(j)])
			currentBuff.get_node("content/costs").add_child(currentCost)
		staticFuncCaller.buffsShow.add_child(currentBuff)
static func generateUnit(target: String, pos: Vector2, boss: bool = false):
	var unit = staticFuncCaller.get_node("units/" + target).duplicate() as entity
	unit.position = pos
	unit.enableAi = true
	unit.isBoss = boss
	unit.name = "enemy_" + target + str(randf_range(100, 999999) + randf_range(100, 999999)) + str(randf_range(10, 200))
	unit.level = ceil((wave * randf_range(0.7, 1.3) + randi_range(0, 1)) * (4.0 if boss else 1.0))
	var healthBar = staticFuncCaller.get_node("units/healthBar").duplicate()
	healthBar.name = "healthBar"
	unit.add_child(healthBar)
	staticFuncCaller.add_child(unit)
static func get_all_progress_bars(node):
	var progress_bars = []
	if node is ProgressBar and not node.name.begins_with("ignore_bgbar_"):
		progress_bars.append(node)
	for child in node.get_children(true):
		progress_bars.append_array(get_all_progress_bars(child))
	return progress_bars
static func shrimpRate(rate: float, maxCount: int):
	var result = 1
	while randf() < rate and (result < maxCount or maxCount <= 0):
		result += 1
	return result
static func getAllEnemies():
	var result = []
	for i in staticFuncCaller.get_children():
			if i.name.begins_with("enemy_"):
				result.append(i)
	return result
static func findBoss():
	var enimies = getAllEnemies()
	for i in enimies:
		if i.isBoss:
			return i
	return null
static func createWeaponLabel(i: int):
	var currentWeapon = weaponExample.duplicate()
	currentWeapon.name = "w" + str(i)
	currentWeapon.get_node("block/num").text = str(i + 1)
	currentWeapon.get_node("name").text = userData.weapons[i].displayName
	currentWeapon.get_node("texture").texture = userData.weapons[i].icon
	weaponShow.add_child(currentWeapon)
