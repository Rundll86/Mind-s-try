extends Button
var animator
func _ready():
	pressed.connect(on_pressed)
	animator = $"/root/world/ui-layer/ui-show/panels/bg/waveTip/bar/buffs/animator" as AnimationPlayer
	animator.animation_finished.connect(resetBuffAndShow)
func on_pressed():
	print(init.resetBuffCostSaved)
	if init.inventory["copper"]["count"] < init.resetBuffCostSaved:
		return
	init.inventory["copper"]["count"] -= init.resetBuffCostSaved
	init.resetBuffCostSaved=int(init.resetBuffCostSaved*1.5)
	animator.play("hide")
func resetBuffAndShow(anim_name):
	if not anim_name == "hide": return
	init.generateBuffCard()
	animator.play("show")
