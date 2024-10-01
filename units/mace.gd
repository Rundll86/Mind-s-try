extends entity
func CustomAi():
    PRESETAI_followPlayer()
    if playerEntity.global_position.distance_to(global_position) < readBullet("fireScan").lifeTime:
        attackChecked()