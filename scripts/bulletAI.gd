extends Area2D
class_name bulletAI
var startPosition: Vector2;
var startTime: int;
var launcher: entity;
var myTracingTarget: entity;
var damageBooster: float;
@export var speed: float = 1.0;
@export var enable = false;
@export var lifeTime = 700;
@export var damage = 10;
@export var damageFromPlayer = false;
@export var penetrate: float = 0;
@export var tracingTime: float = 0;
@export var tracingSpeed: float = 1;
@export var myDamageType: damageType.Enums = damageType.Enums.COLLITE;
func _ready():
	startPosition = position;
	startTime = Time.get_ticks_msec()
	body_entered.connect(Callable(self, "hitCheck"))
	if enable and canTrace():
		var target
		var enemies = init.getAllEnemies()
		if len(enemies) > 0:
			if damageFromPlayer:
				target = enemies[randi_range(0, len(enemies) - 1)]
			else:
				target = $/root/world/player
			if target:
				myTracingTarget = target
func _process(_delta):
	if global_position.distance_to(startPosition) > lifeTime and enable:
		queue_free();
	if not enable:
		return
	if canTrace() and is_instance_valid(myTracingTarget):
		var targetRotation = rad_to_deg(myTracingTarget.global_position.angle_to_point(global_position))
		var rotationDiff = global_rotation_degrees - targetRotation
		if rotationDiff > 180:
			rotationDiff -= 360
		if rotationDiff < -180:
			rotationDiff += 360
		if abs(rotationDiff) < tracingSpeed:
			global_rotation_degrees = targetRotation
		else:
			if rotationDiff > 0:
				global_rotation_degrees -= tracingSpeed
			else:
				global_rotation_degrees += tracingSpeed
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
	var damageResult = damage * (1 + randf_range(-0.1, 0.1)) * (1 + damageBooster)
	var crit = false
	if is_instance_valid(launcher):
		crit = randf() < launcher.critRate;
		if crit:
			damageResult *= 1 + launcher.critDamageBoost
	body.hit(damageResult, crit, damageBooster, myDamageType)
	if randf() < penetrate:
		return
	queue_free()
func canTrace():
	return Time.get_ticks_msec() - startTime < tracingTime