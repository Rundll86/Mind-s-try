extends Node2D
class_name damageNode
var isSubstance = true;
var animator;
func _ready():
    if isSubstance: return
    animator = $animator
    animator.play("jump")
    animator.animation_finished.connect((func(_nothing): queue_free()))