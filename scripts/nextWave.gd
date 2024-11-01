extends Button
var player: entity;
func _ready():
	connect("pressed", pressed)
	player = $/root/world/player
func pressed():
	init.wave += 1
	for i in init.readWaves:
		if (
			init.wave >= i.fromWave and
			(i.toWave < 1 or init.wave <= i.toWave) and
			i.visible and
			(init.wave - i.fromWave)%i.perWaves == 0
		):
			var count = init.shrimpRate(i.rateBoost, i.maxCount)
			if i.spawnAsBoss:
				count = 1
			for j in range(count):
				var pos = player.position
				while (pos.distance_to(player.position) < 300):
					pos = Vector2(
						randf_range(-i.spawnRandomPosition.x, i.spawnRandomPosition.x),
						randf_range(-i.spawnRandomPosition.y, i.spawnRandomPosition.y)
					)
				init.generateUnit(i.target.name, pos, i.spawnAsBoss)
	panelDefine.closeCurrent()
	if init.wave == 1:
		panelDefine.checkToTip(0)
	elif init.wave == 3:
		panelDefine.checkToTip(1)
	elif init.wave == 4:
		panelDefine.checkToTip(2)
	elif init.wave == 8:
		panelDefine.checkToTip(3)
	elif player.haveBuffCount > 3:
		panelDefine.checkToTip(4)
	elif player.heat >= player.overclockNeedsHeat and player.mrj >= player.overclockNeedsMrj:
		panelDefine.checkToTip(5)
	elif player.heat >= player.superclockNeedsHeatPercent * player.heatMax and player.mrj >= player.superclockNeedsMrjPercent * player.mrjMax:
		panelDefine.checkToTip(6)
	save.saveData()
