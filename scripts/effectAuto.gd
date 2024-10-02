extends GPUParticles2D
class_name effectAuto
func _ready():
    emitting = true
func _process(_delta):
    if not emitting:
        queue_free()
func _draw():
    emitter()
func emitter():
    pass