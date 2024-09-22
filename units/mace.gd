extends entity
var parts: GPUParticles2D;
func _ready():
    super._ready()
    parts = $texture/bulletSpawner/parts
    parts.one_shot = true
func CustomAi():
    PRESETAI_followPlayer()
    if playerEntity.global_position.distance_to(global_position) < readBullet("fireScan").lifeTime:
        attackChecked()
func attack():
    parts.emitting = true
    launchBullet("fireScan")
