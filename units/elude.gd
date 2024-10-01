extends entity;
func CustomAi():
	PRESETAI_followPlayer()
	if playerEntity.global_position.distance_to(global_position) < readBullet("tracingBullet").lifeTime:
		attackChecked()
