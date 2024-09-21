extends Node2D;
class_name init;
var enemyCount = 0;
static var isPlayerAlive: bool = true;
static var inventory = {};
static var waves = [
	[["dagger"], [0.5]],
	[["stell"], [0.5]],
	[["mace"], [0.5]]
];
static var animationSpeed = [0.8, 0.01];
static var wave = 0;
func _ready():
	$projectiles.hide()
	$units.hide()
	$items.hide()
	for i in $camera/ui/infos/inventory.get_children():
		inventory[i.name] = {
			"count": 0,
			"label": i.get_node("Label")
		}
func _process(_delta):
	for i in inventory.values():
		i["label"].text = str(i["count"])
	if wave < len(waves):
		enemyCount = 0
		for i in get_children():
			if i.name.begins_with("enemy_"):
				enemyCount += 1
		if enemyCount == 0:
			print(waves[wave][0], waves[wave][1])
			generateWave(waves[wave][0], waves[wave][1])
			wave += 1
	for i in get_all_progress_bars(self):
		var current = i.get_node_or_null("ignore_bgbar_myBgbar")
		if not current:
			var bar = $camera/ui/health/ignore_bgbar_myBgbar.duplicate()
			bar.name = "ignore_bgbar_myBgbar"
			i.add_child(bar)
			print("added bar " + i.name)
func generateUnit(target: String, pos: Vector2):
	var unit = get_node("units/" + target).duplicate() as entity
	unit.position = pos
	unit.enableAi = true
	unit.name = "enemy_" + target + str(randi_range(10000, 99999))
	add_child(unit)
func generateWave(units: Array, rates: Array):
	for i in range(len(units)):
		for j in range(shrimpRate(rates[i], -1)):
			generateUnit(units[i], Vector2(randf_range(-500, 500), randf_range(-500, 500)))
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