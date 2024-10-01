extends Node2D;
class_name init;
static var isPlayerAlive: bool = true;
static var inventory = {};
static var animationSpeed = [0.8, 0.01];
static var wave = 0;
static var staticFuncCaller;
static var readWaves: Array[waveDefine] = [];
static var isSelectingBuff: bool = false;
static var enemyCount = 0;
var bossBar: ProgressBar;
var bossAvatar: TextureRect;
var bossName: Label;
var bossValue: Label;
var weaponShow;
var waveTip;
var buffsShow;
var buffCardExample;
func _ready():
	$projectiles.hide()
	$units.hide()
	$items.hide()
	$effects.hide()
	for i in $buffs.get_children():
		buff.collections.append(i)
	waveTip = $camera/waveTip
	buffsShow = waveTip.get_node("panel/bar/buffs")
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
func _process(_delta):
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
		waveTip.get_node("panel/bar/title").text = "Wave " + str(wave + 1) + " Cleared!"
		isSelectingBuff = true
		for i in buffsShow.get_children():
			buffsShow.remove_child(i)
		buff.collections.shuffle()
		for i in buff.collections.slice(0, 3):
			var entries = ""
			if i.healthMax > 0:
				entries += "生命值上限+" + str(i.healthMax) + "\n"
			if i.attackSpeed > 0:
				entries += "攻击速度加成+" + str(i.attackSpeed) + "%\n"
			if i.attackDamage > 0:
				entries += "伤害加成+" + str(i.attackDamage) + "%\n"
			if i.movementSpeed > 0:
				entries += "移动速度+" + str(i.movementSpeed) + "%\n"
			if i.critRate > 0:
				entries += "暴击率+" + str(i.critRate) + "%\n"
			if i.critDamage > 0:
				entries += "暴击伤害+" + str(i.critDamage) + "%\n"
			if i.evasion > 0:
				entries += "闪避率+" + str(i.evasion) + "%\n"
			var currentBuff = buffCardExample.duplicate()
			currentBuff.get_node("content/name").text = i.displayName
			currentBuff.get_node("content/texture").texture = i.texture
			currentBuff.get_node("content/entry").text = entries;
			var clonedI = i.duplicate() as buff
			clonedI.name = "attrs"
			var currentSelectButton = currentBuff.get_node("content/select")
			currentSelectButton.remove_child(currentSelectButton.get_node("attrs"))
			currentSelectButton.add_child(clonedI)
			buffsShow.add_child(currentBuff)
		waveTip.get_node("animator").play("show")
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
		bossBar.value = currentBoss.health
		bossAvatar.texture = currentBoss.texture.texture
		bossName.text = currentBoss.displayName
		bossValue.text = str(int(currentBoss.health)) + "/" + str(int(currentBoss.healthMax))
static func generateUnit(target: String, pos: Vector2, boss: bool = false):
	var unit = staticFuncCaller.get_node("units/" + target).duplicate() as entity
	unit.position = pos
	unit.enableAi = true
	unit.isBoss = boss
	unit.name = "enemy_" + target + str(randi_range(100, 999999)) + str(randi_range(100, 999999))
	unit.level = wave * 2 + randi_range(0, 10)
	staticFuncCaller.add_child(unit)
func get_all_progress_bars(node):
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