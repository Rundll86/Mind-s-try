extends RigidBody2D;
class_name entity;
#数值
var health:float=0;
var slagMax:float=50;
var slag:float=0;
var coolantMax:float=200;
var coolant:float=0;
var oilMax:float=100;
var oil:float=0;
#元数据
var texture: Sprite2D;
var hitbox: CollisionShape2D;
var animator:AnimationPlayer;
var damageLabel:damageNode;
var currentWeaponIndex=-1;
#数值显示条
var healthBar:ProgressBar;
var levelLabel:Label;
var slagBar:ProgressBar;
var coolantBar:ProgressBar;
var oilBar:ProgressBar;
#间隔计算
var lastAttackTime = 0;
var lastOilDamageTime=0;
var lastWeaponLaunchTime=0;
#常量
var playerEntity:entity;
#已储存的数值基质
var healthMaxSaved:float=0;
var attackDamageSaved:float=0;
#---
#选项
@export var enableAi:bool=false;
@export var playerControlled:bool = false;
@export var useGodMode:bool=false;
@export var damageFromPlayer:bool=false;
@export var isBoss:bool=false;
#间隔设置
@export var attackLimit:float=300;
@export var weaponLaunchLimit:float=100;
#数值
@export var animationSpeed:float = 0.2;
@export var rotateSpeedMax:float=-1;
#掉落物
@export var drops:Array[item]=[];
@export var dropMinCounts:Array[int]=[];
@export var dropMaxCounts:Array[int]=[];
@export var dropRange:float=100;
#武器
@export var weapons:Array[weapon];
#词条
@export var displayName="未知单位"
@export var healthMax:float=100;
@export var shootOffset:float=10;
@export var moveSpeed:float = 1;
@export var critRate=0.05;
@export var critDamageBoost=1;
@export var level=1;
@export var evasion:float = 0;
@export var attackSpeed:float = 1;
@export var attackDamage:float = 1;
@export var moveSpeedBoost:float = 0;
func _ready():
	healthMaxSaved=healthMax
	attackDamageSaved=attackDamage
	setLevel(level)
	damageLabel=$/root/world/damage as damageNode
	z_index=2
	texture = $texture
	hitbox = $hitbox
	animator = $texture/animator
	lock_rotation = true
	playerEntity = get_node("/root/world/player")
	if useGodMode:
		healthMax*=20
		attackSpeed*=3
	health=healthMax
	healthBar=get_node_or_null("healthBar")
	if healthBar:
		levelLabel=healthBar.get_node("level")
	if playerControlled:
		healthBar = get_node("/root/world/camera/ui/health")
		slagBar = get_node("/root/world/camera/ui/slag")
		coolantBar = get_node("/root/world/camera/ui/coolant")
		oilBar = get_node("/root/world/camera/ui/oil")
		coolant=coolantMax
		oil=oilMax
	if enableAi:
		hitbox.scale=Vector2(1,1)
func _process(_delta):
	hitbox.disabled = not enableAi
	if healthBar:
		healthBar.value+=(health-healthBar.value)*(init.animationSpeed[0])
		healthBar.max_value=healthMax
		if levelLabel:levelLabel.text="Lv."+str(level)
	health=min(health,healthMax)
	if playerControlled:
		slag=min(slag,slagMax)
		coolant=min(coolant,coolantMax)
		oil=min(oil,oilMax)
		slagBar.value+=(slag-slagBar.value)*(init.animationSpeed[0])
		slagBar.max_value=slagMax
		coolantBar.value+=(coolant-coolantBar.value)*(init.animationSpeed[0])
		coolantBar.max_value=coolantMax
		oilBar.value+=(oil-oilBar.value)*(init.animationSpeed[0])
		oilBar.max_value=oilMax
		if not init.isSelectingBuff:
			var movingUp = Input.is_action_pressed("moveup")
			var movingDown = Input.is_action_pressed("movedown")
			var movingLeft = Input.is_action_pressed("moveleft")
			var movingRight = Input.is_action_pressed("moveright")
			var moved = Input.is_action_pressed("moving")
			if moved:
				if movingUp and movingLeft:
					texture.rotation_degrees += (-45 - texture.rotation_degrees) * animationSpeed
				elif movingUp and movingRight:
					texture.rotation_degrees += (45 - texture.rotation_degrees) * animationSpeed
				elif movingDown and movingLeft:
					texture.rotation_degrees += (-135 - texture.rotation_degrees) * animationSpeed
				elif movingDown and movingRight:
					texture.rotation_degrees += (135 - texture.rotation_degrees) * animationSpeed
				elif movingUp:
					texture.rotation_degrees += (0 - texture.rotation_degrees) * animationSpeed
				elif movingDown:
					texture.rotation_degrees += (180 - texture.rotation_degrees) * animationSpeed
				elif movingLeft:
					texture.rotation_degrees += (-90 - texture.rotation_degrees) * animationSpeed
				elif movingRight:
					texture.rotation_degrees += (90 - texture.rotation_degrees) * animationSpeed
				moveForward()
			elif Input.is_action_pressed("attack"):
				texture.rotation_degrees += (
					rad_to_deg(get_local_mouse_position().angle_to_point(Vector2.ZERO))
					- 90
					- texture.rotation_degrees
					) * animationSpeed;
				attackChecked()
			if Input.is_action_pressed("heal")and health<healthMax:
				health+=healthMax*0.01
				slag+=1
			if Input.is_action_pressed("cool")and slag>0 and coolant>0:
				slag-=1
				coolant-=1
				oil+=0.4
		if slag>slagMax:
			var diff=slag-slagMax
			oil-=diff
		if oil<oilMax:
			var diff=oil/oilMax
			if Time.get_ticks_msec()-lastOilDamageTime>1000*diff:
				hit(1,false,0,damageType.Enums.BIOEROSION)
				lastOilDamageTime=Time.get_ticks_msec()
	if enableAi&&init.isPlayerAlive:CustomAi()
	if currentWeaponIndex>=0 and currentWeaponIndex<len(weapons) and Time.get_ticks_msec()-lastWeaponLaunchTime>weaponLaunchLimit/attackSpeed:
		var currentWeapon=weapons[currentWeaponIndex]
		launchBullet(
			currentWeapon.bullet,
			currentWeapon,
			(slag/slagMax if currentWeapon.bullet.myDamageType==damageType.Enums.HIGH_T else 0.0)*(oil/oilMax)+attackDamage-1
		)
		currentWeapon.audioPlayer.play()
		if currentWeapon.shootEffect:
			var cloned=currentWeapon.shootEffect.duplicate() as effectAuto
			currentWeapon.add_child(cloned)
		currentWeaponIndex+=1
		lastWeaponLaunchTime=Time.get_ticks_msec()
func setLevel(newLevel):
	var healthRatio=health/healthMax
	level=newLevel
	healthMax=level*randi_range(15,25)+healthMaxSaved
	health=healthRatio*healthMax
	attackDamage=level*randf_range(0.01,0.03)+attackDamageSaved
func upgradeLevel(step:int=1):
	level+=step
	var healthRatio=health/healthMax
	healthMax+=step*randi_range(15,25)
	health=healthRatio*healthMax
	attackDamage+=step*randf_range(0.01,0.03)
func readBullet(bullet:String):
	return get_node("/root/world/projectiles/"+bullet) as bulletAI
func moveForward():
	apply_central_force(Vector2(
		sin(texture.rotation),
		-cos(texture.rotation)
	) * moveSpeed * 600*(moveSpeedBoost+1))
func canAttack():
	return (Time.get_ticks_msec()-lastAttackTime)>(attackLimit+len(weapons)*weaponLaunchLimit)/attackSpeed
func launchBullet(bulletSubstance:bulletAI,spawner:Node2D,damageBooster:float=0):
	var bullet=bulletSubstance.duplicate() as bulletAI
	bullet.position = spawner.global_position
	bullet.global_rotation_degrees = texture.global_rotation_degrees+randf_range(-shootOffset,shootOffset)
	bullet.enable=true
	bullet.launcher=self
	bullet.damageBooster=damageBooster
	bullet.damageFromPlayer=damageFromPlayer
	get_node("/root/world").add_child(bullet)
func launchWeapon():
	currentWeaponIndex=0
func attackChecked():
	if canAttack():
		attack()
		lastAttackTime=Time.get_ticks_msec()
func attack():
	launchWeapon()
func CustomAi():
	pass
func hit(damage:int,crit:bool,damageBoost:float,myDamageType:damageType.Enums):
	if randf_range(0,1)<evasion:
		return
	animator.play("hit")
	health -= damage
	var currentDamageLabel=damageLabel.duplicate() as damageNode
	currentDamageLabel.isSubstance=false
	currentDamageLabel.global_position=global_position+Vector2(
		randf_range(-20,20),
		randf_range(-20,20)
	)
	var labelComponet=currentDamageLabel.get_node("label") as Label
	labelComponet.text=str(ceil(damage))+("!!!"if crit else "")
	labelComponet.add_theme_color_override("font_color",damageType.colorMapper[myDamageType])
	var labelBoostComponet=labelComponet.get_node("boost")
	labelBoostComponet.text=str("%.1f"%(damageBoost*100))+"%"
	get_node("/root/world").add_child(currentDamageLabel)
	if health<=0:
		if playerControlled:
			($/root/world/camera/gameoverLay as ColorRect).show()
			($/root/world/camera/gameoverLay/animator as AnimationPlayer).play("show")
			init.isPlayerAlive=false
			healthBar.value=health
			healthBar.max_value=healthMax
		for i in range(len(drops)):
			for j in range(randi_range(
				dropMinCounts[i],
				dropMaxCounts[i]
			)):
				var drop = drops[i].duplicate() as item
				drop.itemID=drops[i].name
				drop.isSubstance=false
				get_node("/root/world").call_deferred("add_child",drop)
		queue_free()
func PRESETAI_followPlayer():
	if init.isPlayerAlive:
		var target=rad_to_deg(playerEntity.position.angle_to_point(position))-90
		texture.rotation_degrees += (target - texture.rotation_degrees) * animationSpeed*0.15
		moveForward()
