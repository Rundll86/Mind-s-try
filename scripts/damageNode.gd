extends Node2D
class_name damageNode
var isSubstance = true;
var animator;
static var dps = 0;
static var lastClearDPSTime = 0;
func _ready():
    if isSubstance: return
    animator = $animator
    animator.play("jump")
    animator.animation_finished.connect((func(_nothing): queue_free()))
func _process(_delta):
    if Time.get_ticks_msec() - lastClearDPSTime > 1000:
        dps = 0
        lastClearDPSTime = Time.get_ticks_msec()