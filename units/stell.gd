extends entity;
func attack():
	launchBullet("basicBullet")
func CustomAi():
	texture.rotation_degrees = rad_to_deg(playerEntity.global_position.angle_to_point(global_position)) - 90
	moveForward()
	if playerEntity.global_position.distance_to(global_position) < readBullet("basicBullet").lifeTime:
		attackChecked()
