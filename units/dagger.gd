extends entity;
func _ready():
	super._ready()
func attack():
	launchBullet("basicBullet")
	launchBullet("basicBullet")
func CustomAi():
	PRESETAI_followPlayer()
	if playerEntity.global_position.distance_to(global_position) < readBullet("basicBullet").lifeTime:
		attackChecked()
