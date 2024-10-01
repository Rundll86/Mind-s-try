extends entity;
func attack():
	launchWeapon()
	queue_free()
func CustomAi():
	PRESETAI_followPlayer()
	if playerEntity.global_position.distance_to(global_position) < readBullet("selfDestruct").lifeTime:
		attackChecked()
