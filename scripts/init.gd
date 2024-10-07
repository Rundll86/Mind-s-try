extends Node2D;
class_name init;
static var isPlayerAlive: bool = true;
static var inventory = {};
static var animationSpeed = [0.7, 0.01];
static var wave = 0;
static var staticFuncCaller;
static var readWaves: Array[waveDefine] = [];
static var isSelectingBuff: bool = false;
static var enemyCount = 0;
static var resetBuffCostSaved: int = 0;
var bossBar: ProgressBar;
var bossAvatar: TextureRect;
var bossName: Label;
var bossValue: Label;
var weaponShow;
var waveTip;
var buffsShow;
var buffCardExample;
var buffCostCardExample;
@export var initWave: int = 1;
@export var initItems: Array[item] = [];
@export var initItemCounts: Array[int] = [];
@export var resetBuffCost: int = 30;
func _ready():
	resetBuffCostSaved = resetBuffCost
	$projectiles.hide()
	$units.hide()
	$items.hide()
	$effects.hide()
	for i in $buffs.get_children():
		buff.collections.append(i)
	waveTip = $camera/waveTip
	wave = initWave - 1
	buffsShow = waveTip.get_node("panel/bar/buffs")
	buffCostCardExample = buffsShow.get_node("example/content/costs/example")
	buffCostCardExample.get_parent().remove_child(buffCostCardExample)
	buffCardExample = buffsShow.get_node("example")
	buffCardExample.get_parent().remove_child(buffCardExample)
	bossBar = $camera/bossHealth
	bossAvatar = bossBar.get_node("avatar")
	bossName = bossAvatar.get_node("name")
	bossValue = bossBar.get_node("value")
	weaponShow = $"camera/mamba-out/weapons"
	var weaponExample: HBoxContainer = weaponShow.get_node("w0")
	weaponExample.get_parent().remove_child(weaponExample)
	for i in userData.weapons:
		var currentWeapon = weaponExample.duplicate()
		currentWeapon.name = "w" + str(userData.weapons.find(i))
		currentWeapon.get_node("block/num").text = str(userData.weapons.find(i) + 1)
		currentWeapon.get_node("name").text = i.displayName
		currentWeapon.get_node("texture").texture = i.icon
		weaponShow.add_child(currentWeapon)
	for i in $waves.get_children():
		readWaves.append(i)
	staticFuncCaller = self
	for i in $camera/ui/infos/inventory.get_children():
		inventory[i.name] = {
			"count": 0,
			"label": i.get_node("Label")
		}
	for i in range(len(initItems)):
		inventory[initItems[i].name]["count"] += initItemCounts[i]
	# $/root/world/player.setLevel(wave)
func _process(_delta):
	waveTip.get_node("panel/bar/tools/cost").text = str(resetBuffCostSaved)
	if Input.is_action_just_pressed("nextweapon"):
		userData.currentWeapon += 1
		if userData.currentWeapon >= len(userData.weapons):
			userData.currentWeapon = 0
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
	for i in inventory.values():
		i["label"].text = str(i["count"])
	enemyCount = 0
	for i in get_children():
		if i.name.begins_with("enemy_"):
			enemyCount += 1
	if enemyCount == 0 and not isSelectingBuff:
		waveTip.get_node("panel/bar/title/title").text = "Wave " + str(wave + 1) + " Cleared!"
		isSelectingBuff = true
		resetBuffCostSaved = resetBuffCost
		generateBuffCard()
		waveTip.get_node("animator").play("show")
		waveTip.get_node("panel/bar/buffs/animator").play("show")
	for i in get_all_progress_bars(self):
		var current = i.get_node_or_null("ignore_bgbar_myBgbar")
		if not current:
			var bar = $camera/ui/health/ignore_bgbar_myBgbar.duplicate()
			bar.name = "ignore_bgbar_myBgbar"
			i.add_child(bar)
			print("added bar " + i.name)
	var currentBoss = findBoss()
	bossBar.visible = currentBoss != null
	if currentBoss:
		bossBar.max_value = currentBoss.healthMax
		bossBar.value = currentBoss.healthBar.value
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
			entries += "装甲载荷+" + str(i.healthMax) + "\n"
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
			entries += "冷却液上限+" + str(i.coolant) + "\n"
		if i.oil > 0:
			entries += "芳油上限+" + str(i.oil) + "\n"
		if i.slag > 0:
			entries += "矿渣上限+" + str(i.slag) + "\n"
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
	unit.level = ceil(wave * randf_range(0.7, 1.3)) + randi_range(-1, 1) + (randi_range(35, 55) if boss else 0)
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
