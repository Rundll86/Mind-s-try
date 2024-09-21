extends entity
var parts: GPUParticles2D;
func _ready():
    super._ready()
    parts = $texture/bulletSpawner/parts
    parts.one_shot = true
func CustomAi():
    texture.rotation_degrees = rad_to_deg(playerEntity.global_position.angle_to_point(global_position)) - 90
    moveForward()
    if playerEntity.global_position.distance_to(global_position) < readBullet("fireScan").lifeTime:
        attackChecked()
func attack():
    parts.emitting = true
    launchBullet("fireScan")
