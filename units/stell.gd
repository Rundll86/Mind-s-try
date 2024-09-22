extends entity;
func attack():
	launchBullet("basicBullet")
func CustomAi():
	PRESETAI_followPlayer()
	if playerEntity.global_position.distance_to(global_position) < readBullet("basicBullet").lifeTime:
		attackChecked()
