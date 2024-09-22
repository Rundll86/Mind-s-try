extends Area2D
class_name bulletAI
var startPosition;
var launcher: RigidBody2D;
@export var speed = 1;
@export var enable = false;
@export var lifeTime = 700;
@export var damage = 10;
@export var damageFromPlayer: bool = false;
func _ready():
	startPosition = position;
	body_entered.connect(Callable(self, "hitCheck"))
func _process(_delta):
	if global_position.distance_to(startPosition) > lifeTime and enable:
		print("rmd self")
		queue_free();
	if not enable:
		return
	position += Vector2.from_angle(deg_to_rad(global_rotation_degrees - 90)) * speed * 10
func hitCheck(body: entity):
	if not enable or not body.enableAi:
		return
	if body.playerControlled:
		if damageFromPlayer:
			return
	else:
		if !damageFromPlayer:
			return
	body.hit(ceil(damage * (1 + randf_range(-0.5, 0.5))))
	queue_free()