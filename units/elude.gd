extends entity;
func attack():
	launchBullet("selfDestruct")
	queue_free()
func CustomAi():
	PRESETAI_followPlayer()
