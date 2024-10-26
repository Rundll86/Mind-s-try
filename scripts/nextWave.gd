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
			(init.wave-i.fromWave)%i.perWaves==0
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
	save.saveData()
