extends RigidBody2D;
class_name entity;
var texture: Sprite2D;
var hitbox: CollisionShape2D;
var bulletSpawner:Node2D;
var bulletSpawnerAsp:AudioStreamPlayer2D;
var animator:AnimationPlayer;
var lastAttackTime = 0;
var playerEntity:entity;
var health:float;
var healthBar:ProgressBar;
var slagBar:ProgressBar;
var coolantBar:ProgressBar;
var oilBar:ProgressBar;
var slagMax:float=50;
var slag:float=0;
var coolantMax:float=200;
var coolant:float;
var oilMax:float=100;
var oil:float;
var lastOilDamageTime=0;
var damageLabel:damageNode;
@export var enableAi:bool=false;
@export var playerControlled:bool = false;
@export var animationSpeed:float = 0.2;
@export var moveSpeed:float = 1;
@export var attackLimit:float=300;
@export var shootOffset:float=10;
@export var healthMax:float=100;
@export var damageFromPlayer=false;
@export var drops:Array[item]=[]
@export var dropCounts:Array[float]=[]
@export var dropRange:float=100;
@export var useGodMode:bool=false;
@export var rotateSpeedMax:float=-1;
func _ready():
	damageLabel=$/root/world/damage as damageNode
	z_index=2
	texture = $texture
	hitbox = $hitbox
	bulletSpawner = $texture/bulletSpawner
	bulletSpawnerAsp=$texture/bulletSpawner/asp
	animator = $texture/animator
	lock_rotation = true
	playerEntity = get_node("/root/world/player")
	if useGodMode:
		healthMax*=10
		attackLimit/=1
	health=healthMax
	healthBar=get_node_or_null("healthBar")
	if playerControlled:
		healthBar = get_node("/root/world/camera/ui/health")
		slagBar = get_node("/root/world/camera/ui/slag")
		coolantBar = get_node("/root/world/camera/ui/coolant")
		oilBar = get_node("/root/world/camera/ui/oil")
		coolant=coolantMax
		oil=oilMax
func _process(_delta):
	healthBar.value+=(health-healthBar.value)*(init.animationSpeed[0])
	healthBar.max_value=healthMax
	if playerControlled:
		if oil>oilMax:
			oil=oilMax
		slagBar.value+=(slag-slagBar.value)*(init.animationSpeed[0])
		slagBar.max_value=slagMax
		coolantBar.value+=(coolant-coolantBar.value)*(init.animationSpeed[0])
		coolantBar.max_value=coolantMax
		oilBar.value+=(oil-oilBar.value)*(init.animationSpeed[0])
		oilBar.max_value=oilMax
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
			moveForward()
		if Input.is_action_pressed("attack"):
			texture.rotation_degrees += (
				rad_to_deg(get_local_mouse_position().angle_to_point(Vector2.ZERO))
				 - 90
				 - texture.rotation_degrees
				) * animationSpeed;
			attackChecked()
		if Input.is_action_pressed("heal")and health<healthMax:
			health+=1
			slag+=1
		if Input.is_action_pressed("cool")and slag>0 and coolant>0:
			slag-=1
			coolant-=1
			oil+=0.4
		if slag>slagMax:
			var diff=slag-slagMax
			slag=slagMax
			oil-=diff
		if oil<oilMax:
			var diff=oil/oilMax
			if Time.get_ticks_msec()-lastOilDamageTime>1000*diff:
				hit(1)
				lastOilDamageTime=Time.get_ticks_msec()
	if enableAi&&init.isPlayerAlive:CustomAi()
func readBullet(bullet:String):
	return get_node("/root/world/projectiles/"+bullet) as bulletAI
func moveForward():
	apply_central_force(Vector2(
		sin(texture.rotation),
		-cos(texture.rotation)
	) * moveSpeed * 600)
func canAttack():
	return (Time.get_ticks_msec()-lastAttackTime)>attackLimit
func launchBullet(bulletType:String):
	if not canAttack():
		return
	var bullet = readBullet(bulletType).duplicate() as bulletAI
	bullet.position = bulletSpawner.global_position
	bullet.global_rotation_degrees = texture.global_rotation_degrees+randf_range(-shootOffset,shootOffset)
	bullet.enable=true
	bullet.launcher=self
	bullet.damageFromPlayer=damageFromPlayer
	get_node("/root/world").add_child(bullet)
	bulletSpawnerAsp.play()
func attackChecked():
	if canAttack():
		attack()
		lastAttackTime=Time.get_ticks_msec()
func attack():
	launchBullet("basicBullet")
	launchBullet("basicBullet")
func CustomAi():
	pass
func hit(damage:int):
	animator.play("hit")
	health -= damage
	var currentDamageLabel=damageLabel.duplicate() as damageNode
	currentDamageLabel.isSubstance=false
	currentDamageLabel.get_node("label").text=str(damage)
	currentDamageLabel.global_position=global_position+Vector2(
		randf_range(-50,50),
		randf_range(-50,50)
	)
	get_node("/root/world").add_child(currentDamageLabel)
	if health<=0:
		if playerControlled:
			($/root/world/camera/gameoverLay as ColorRect).show()
			($/root/world/camera/gameoverLay/animator as AnimationPlayer).play("show")
			init.isPlayerAlive=false
			healthBar.value=health
			healthBar.max_value=healthMax
		for i in range(len(drops)):
			for j in range(init.shrimpRate(dropCounts[i]*0.01,-1)):
				var drop = drops[i].duplicate() as item
				drop.canBeCollect=true
				drop.itemId=drops[i].name
				drop.global_position = global_position+Vector2(
					randf_range(-dropRange,dropRange),
					randf_range(-dropRange,dropRange)
				)
				get_node("/root/world").add_child(drop)
		queue_free()
func PRESETAI_followPlayer():
	if init.isPlayerAlive:
		var target=rad_to_deg(playerEntity.position.angle_to_point(position))-90
		texture.rotation_degrees += (target - texture.rotation_degrees) * animationSpeed*0.15
		moveForward()
