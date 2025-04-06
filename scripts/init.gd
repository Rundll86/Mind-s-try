extends Node2D;
class_name init;
static var isPlayerAlive: bool = true;
static var inventory = {};
static var animationSpeed = [0.7, 0.01];
static var wave: int = 0;
static var staticFuncCaller: init;
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
static var saveLoaded: bool = false;
var bossBarExample: Node;
var waveTip;
var buffsShow;
var buffCardExample: Node;
var buffCostCardExample;
var buffCardEntryBoxExample: Node;
@export var initWave: int = 1;
@export var initItems: Array[item] = [];
@export var initItemCounts: Array[int] = [];
@export var resetBuffCost: int = 30;
@export var loadSave: bool = true;
func _ready():
	$projectiles.hide()
	$units.hide()
	$items.hide()
	$effects.hide()
	staticFuncCaller = self
	playerEntity = $/root/world/player
	waveTip = $"ui-layer/ui-show/panels/bg/waveTip"
	wave = initWave - 1
	buffsShow = waveTip.get_node("bar/buffs")
	buffCostCardExample = buffsShow.get_node("example/content/costs/example")
	buffCostCardExample.get_parent().remove_child(buffCostCardExample)
	buffCardExample = buffsShow.get_node("example")
	buffCardExample.get_parent().remove_child(buffCardExample)
	buffCardEntryBoxExample = buffCardExample.get_node("content/entry/box")
	buffCardEntryBoxExample.get_parent().remove_child(buffCardEntryBoxExample)
	bossBarExample = $"ui-layer/ui-show/board/bossHealthBars/example"
	bossBarExample.get_parent().remove_child(bossBarExample)
	weaponShow = $"ui-layer/ui-show/board/mamba-out/weapons"
	weaponExample = weaponShow.get_node("w0")
	weaponExample.get_parent().remove_child(weaponExample)
	entriesContainer = $"ui-layer/ui-show/board/infos/damage/cont/panels/entries/container"
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
	for i in $buffs.get_children():
		buff.collections.append(i)
	for i in $waves.get_children():
		readWaves.append(i)
	if loadSave: save.loadData()
	if not saveLoaded:
		#若无法加载存档则加载默认数值
		resetBuffCostSaved = resetBuffCost
		for i in range(len(initItems)):
			inventory[initItems[i].name]["count"] += initItemCounts[i]
	for i in range(len(userData.weapons)):
		createWeaponLabel(i)
	$"ui-layer".show()
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
static func createEntryBoxWith(Name, Unit, Value) -> entryBox:
	var currentBox: entryBox = staticFuncCaller.buffCardEntryBoxExample.duplicate()
	currentBox.entryName = Name
	currentBox.entryUnit = Unit
	currentBox.entryValue = Value
	return currentBox
static func generateBuffCard():
	for i in staticFuncCaller.buffsShow.get_children():
		if i.name != "animator": staticFuncCaller.buffsShow.remove_child(i)
	buff.collections.shuffle()
	for _i in buff.collections.slice(0, 3):
		var i: buff = _i
		var entryBoxes: Array[entryBox] = [];
		if i.healthMax != 0:
			entryBoxes.append(
				createEntryBoxWith(
					"生命上限",
					entryBox.EntryUnit.NONE,
					i.healthMax
				)
			)
		if i.attackSpeed != 0:
			entryBoxes.append(
				createEntryBoxWith(
					"攻击速度",
					entryBox.EntryUnit.PERCENT,
					i.attackSpeed * 0.01
				)
			)
		if i.attackDamage != 0:
			entryBoxes.append(
				createEntryBoxWith(
					"伤害倍率",
					entryBox.EntryUnit.PERCENT,
					i.attackDamage * 0.01
				)
			)
		if i.movementSpeed != 0:
			entryBoxes.append(
				createEntryBoxWith(
					"移动速度",
					entryBox.EntryUnit.PERCENT,
					i.movementSpeed * 0.01
				)
			)
		if i.critRate != 0:
			entryBoxes.append(
				createEntryBoxWith(
					"暴击率",
					entryBox.EntryUnit.PERCENT,
					i.critRate * 0.01
				)
			)
		if i.critDamage != 0:
			entryBoxes.append(
				createEntryBoxWith(
					"暴击伤害",
					entryBox.EntryUnit.PERCENT,
					i.critDamage * 0.01
				)
			)
		if i.evasion != 0:
			entryBoxes.append(
				createEntryBoxWith(
					"闪避率",
					entryBox.EntryUnit.PERCENT,
					i.evasion * 0.01
				)
			)
		if i.coolant != 0:
			entryBoxes.append(
				createEntryBoxWith(
					"冷却液上限",
					entryBox.EntryUnit.NONE,
					i.coolant
				)
			)
		if i.oil != 0:
			entryBoxes.append(
				createEntryBoxWith(
					"芳油上限",
					entryBox.EntryUnit.NONE,
					i.oil
				)
			)
		if i.slag != 0:
			entryBoxes.append(
				createEntryBoxWith(
					"矿渣上限",
					entryBox.EntryUnit.NONE,
					i.slag
				)
			)
		if i.addWeapon:
			entryBoxes.append(
				createEntryBoxWith(
					"获得武器",
					entryBox.EntryUnit.TEXT,
					i.addWeapon.displayName
				)
			)
		var currentBuff = staticFuncCaller.buffCardExample.duplicate()
		currentBuff.get_node("content/name").text = i.displayName
		currentBuff.get_node("content/texture").texture = i.texture
		for j in entryBoxes:
			currentBuff.get_node("content/entry").add_child(j)
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
	var unit: entity = staticFuncCaller.get_node("units/" + target).duplicate() as entity
	unit.position = pos
	unit.enableAi = true
	unit.isBoss = boss
	unit.name = "enemy_" + target + str(randf_range(100, 999999) + randf_range(100, 999999)) + str(randf_range(10, 200))
	unit.level = ceil((wave * randf_range(0.7, 1.3) + randi_range(0, 1)) * (4.0 if boss else 1.0))
	if boss:
		var currentBar = staticFuncCaller.bossBarExample.duplicate()
		var currentTransformer = currentBar.get_node("bar/transformer")
		currentTransformer.get_node("avatar").texture = unit.getTexture()
		currentTransformer.get_node("avatar/name").text = unit.displayName
		staticFuncCaller.get_node("ui-layer/ui-show/board/bossHealthBars").add_child(currentBar)
		unit.healthBar = currentBar.get_node("bar")
		unit.healthLabel = currentTransformer.get_node("value")
		unit.levelLabel = currentTransformer.get_node("level")
	else:
		var healthBar = staticFuncCaller.get_node("units/healthBar").duplicate()
		unit.add_child(healthBar)
		unit.healthBar = healthBar
	staticFuncCaller.add_child(unit)
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
static func findBoss() -> Array[entity]:
	var enimies = getAllEnemies()
	var result = []
	for i in enimies:
		if i.isBoss:
			result.append(i)
	return result
static func createWeaponLabel(i: int):
	var currentWeapon = weaponExample.duplicate()
	currentWeapon.name = "w" + str(i)
	currentWeapon.get_node("block/num").text = str(i + 1)
	currentWeapon.get_node("name").text = userData.weapons[i].displayName
	currentWeapon.get_node("texture").texture = userData.weapons[i].icon
	weaponShow.add_child(currentWeapon)
