extends Button
func _ready():
    connect("pressed", pressed)
func pressed():
    init.wave += 1
    for i in init.readWaves:
        if init.wave >= i.fromWave and (i.toWave < 1 or init.wave <= i.toWave) and i.enable:
            var count = init.shrimpRate(i.rateBoost, i.maxCount)
            if i.spawnAsBoss:
                count = 1
            for j in range(count):
                init.generateUnit(i.target.name, Vector2(
                    randf_range(-i.spawnRandomPosition.x, i.spawnRandomPosition.x),
                    randf_range(-i.spawnRandomPosition.y, i.spawnRandomPosition.y),
                ), i.spawnAsBoss)
    init.isSelectingBuff = false
    $/root/world/camera/waveTip/animator.play("hide")