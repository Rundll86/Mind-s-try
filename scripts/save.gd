extends Node;
class_name save;
static var savePath = "user://file0.save";
static func loadData():
	var file = FileAccess.open(savePath, FileAccess.READ)
	if file:
		init.json.parse(file.get_as_text())
		var data = init.json.data
		init.playerEntity.health = data.player.health
		init.playerEntity.healthMax = data.player.healthMax
		init.playerEntity.shootOffset = data.player.shootOffset
		init.playerEntity.moveSpeed = data.player.moveSpeed
		init.playerEntity.critRate = data.player.critRate
		init.playerEntity.critDamageBoost = data.player.critDamageBoost
		init.playerEntity.level = data.player.level
		init.playerEntity.evasion = data.player.evasion
		init.playerEntity.attackSpeed = data.player.attackSpeed
		init.playerEntity.attackDamage = data.player.attackDamage
		init.playerEntity.moveSpeedBoost = data.player.moveSpeedBoost
		init.playerEntity.slagMax = data.player.slagMax
		init.playerEntity.slag = data.player.slag
		init.playerEntity.coolantMax = data.player.coolantMax
		init.playerEntity.coolant = data.player.coolant
		init.playerEntity.oilMax = data.player.oilMax
		init.playerEntity.oil = data.player.oil
		init.playerEntity.neoplasmMax = data.player.neoplasmMax
		init.playerEntity.neoplasm = data.player.neoplasm
		init.playerEntity.heatMax = data.player.heatMax
		init.playerEntity.heat = data.player.heat
		init.playerEntity.mrjMax = data.player.mrjMax
		init.playerEntity.mrj = data.player.mrj
		init.wave = data.wave
		file.close()
	else:
		print("No save file found")
static func saveData():
	FileAccess.open(savePath, FileAccess.WRITE).store_string(calcSavedData())
static func calcSavedData():
	return JSON.stringify({
		"player": {
			"health": init.playerEntity.health,
			"healthMax": init.playerEntity.healthMax,
			"shootOffset": init.playerEntity.shootOffset,
			"moveSpeed": init.playerEntity.moveSpeed,
			"critRate": init.playerEntity.critRate,
			"critDamageBoost": init.playerEntity.critDamageBoost,
			"level": init.playerEntity.level,
			"evasion": init.playerEntity.evasion,
			"attackSpeed": init.playerEntity.attackSpeed,
			"attackDamage": init.playerEntity.attackDamage,
			"moveSpeedBoost": init.playerEntity.moveSpeedBoost,
			"slagMax": init.playerEntity.slagMax,
			"slag": init.playerEntity.slag,
			"coolantMax": init.playerEntity.coolantMax,
			"coolant": init.playerEntity.coolant,
			"oilMax": init.playerEntity.oilMax,
			"oil": init.playerEntity.oil,
			"neoplasmMax": init.playerEntity.neoplasmMax,
			"neoplasm": init.playerEntity.neoplasm,
			"heatMax": init.playerEntity.heatMax,
			"heat": init.playerEntity.heat,
			"mrjMax": init.playerEntity.mrjMax,
			"mrj": init.playerEntity.mrj
		},
		"wave": init.wave
	})
