extends RigidBody2D;
class_name entity;
var texture: AnimatedSprite2D;
var hitbox: CollisionShape2D;
var bulletSpawner:Node2D;
var bulletSpawnerAsp:AudioStreamPlayer2D;
var lastAttackTime = 0;
@export var enableAi=false;
@export var playerControlled = false;
@export var animationSpeed = 0.2;
@export var moveSpeed = 1;
@export var attackLimit=300;
@export var shootOffset=5;
func _ready():
	texture = $texture
	hitbox = $hitbox
	bulletSpawner = $texture/bulletSpawner
	bulletSpawnerAsp=$texture/bulletSpawner/asp
	lock_rotation = true
func _process(_delta):
	if playerControlled:
		var movingUp = Input.is_action_pressed("moveup")
		var movingDown = Input.is_action_pressed("movedown")
		var movingLeft = Input.is_action_pressed("moveleft")
		var movingRight = Input.is_action_pressed("moveright")
		var moved = Input.is_action_pressed("moving")
		if moved:
			if movingUp:
				texture.rotation_degrees += (0 - texture.rotation_degrees) * animationSpeed
			if movingDown:
				texture.rotation_degrees += (180 - texture.rotation_degrees) * animationSpeed
			if movingLeft:
				texture.rotation_degrees += (270 - texture.rotation_degrees) * animationSpeed
			if movingRight:
				texture.rotation_degrees += (90 - texture.rotation_degrees) * animationSpeed
			apply_central_force(Vector2(
				sin(texture.rotation),
				-cos(texture.rotation)
			) * moveSpeed * 500)
		if Input.is_action_pressed("attack"):
			texture.rotation_degrees += (
				rad_to_deg(get_local_mouse_position().angle_to_point(Vector2.ZERO))
				 - 90
				 - texture.rotation_degrees
				) * animationSpeed;
			attackChecked()
	if enableAi:CustomAi()
func canAttack():
	return (Time.get_ticks_msec()-lastAttackTime)>attackLimit
func launchBullet(bulletType:String):
	if not canAttack():
		return
	var bullet = get_node("/root/world/projectiles/" + bulletType).duplicate() as bulletAI
	bullet.position = bulletSpawner.global_position
	bullet.global_rotation_degrees = texture.global_rotation_degrees+randi_range(-shootOffset,shootOffset)
	bullet.enable=true;
	get_node("/root/world").add_child(bullet)
	bulletSpawnerAsp.play()
func attackChecked():
	if canAttack():
		attack()
		lastAttackTime=Time.get_ticks_msec()
func attack():
	launchBullet("basicBullet")
func CustomAi():
	attackChecked()