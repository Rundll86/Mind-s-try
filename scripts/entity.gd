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
var neoplasmMax:float=100;
var neoplasm:float=0;
var heatMax:float=100;
var heat:float=0;
var mrjMax:float=40;
var mrj:float=0;#孢子菌泥，全拼MushRoomJam
#元数据
var texture: Sprite2D;
var hitbox: CollisionShape2D;
var animator:AnimationPlayer;
var damageLabel:damageNode;
var currentWeaponIndex=-1;
var superclocking:bool=false;
var lastSustWeaponEffect:effectAuto;
#数值显示条
var healthBar:valuebar;
var levelLabel:Label;
var slagBar:valuebar;
var coolantBar:valuebar;
var oilBar:valuebar;
var neoplasmBar:valuebar;
var heatBar:valuebar;
var mrjBar:valuebar;
#间隔计算
var lastAttackTime = 0;
var lastOilDamageTime=0;
var lastWeaponLaunchTime=0;
var lastoverclockTime=0;
var lastsuperclockTime=0;
var sustIndex=0;
#常量
var playerEntity:entity;
#已储存的数值基值
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
@export var weapons:Array[Weapon];
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
#关于普通超频
@export var overclockPushForce:float=40000;
@export var overclockNeedsHeat:float=25;
@export var overclockNeedsMrj:float=10;
#关于极限超频
@export var superclockMovementSpeedBoost:float=0.5;#移速提升50%
@export var superclockAttackSpeedBoost:float=0.4;#攻速提升40%
@export var superclockAttackDamageBoost:float=0.2;#伤害提升20%
@export var superclockNeedsHeatPercent:float=1.0;
@export var superclockNeedsMrjPercent:float=1.0;
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
		healthMax*=999
		attackSpeed*=1
		attackDamage*=999
	health=healthMax
	healthBar=get_node_or_null("healthBar")
	if healthBar:
		levelLabel=healthBar.get_node("transformer/level")
	if playerControlled:
		healthBar = get_node("/root/world/ui-layer/ui-show/board/infos/healthMask/health")
		slagBar = get_node("/root/world/ui-layer/ui-show/board/infos/slag")
		coolantBar = get_node("/root/world/ui-layer/ui-show/board/infos/coolant")
		oilBar = get_node("/root/world/ui-layer/ui-show/board/infos/oil")
		neoplasmBar = get_node("/root/world/ui-layer/ui-show/board/infos/neoplasm")
		heatBar = get_node("/root/world/ui-layer/ui-show/board/infos/damage/heatMask/heat")
		mrjBar=get_node("/root/world/ui-layer/ui-show/board/infos/damage/mrjMask/mrj")
		coolant=coolantMax
		oil=oilMax
		heat=heatMax
	if enableAi:
		hitbox.scale=Vector2(1,1)
func _process(_delta):
	hitbox.disabled = not enableAi
	if healthBar:
		healthBar.currentValue=health
		healthBar.maxValue=healthMax
		if levelLabel:levelLabel.text="Lv."+str(level)
	health=max(min(health,healthMax),0)
	if playerControlled:
		slag=max(min(slag,slagMax),0)
		coolant=max(min(coolant,coolantMax),0)
		oil=max(min(oil,oilMax),0)
		neoplasm=max(min(neoplasm,neoplasmMax),0)
		heat=max(min(heat,heatMax),0)
		mrj=max(min(mrj,mrjMax),0)
		slagBar.currentValue=slag
		slagBar.maxValue=slagMax
		coolantBar.currentValue=coolant
		coolantBar.maxValue=coolantMax
		oilBar.currentValue=oil
		oilBar.maxValue=oilMax
		neoplasmBar.currentValue=neoplasm
		neoplasmBar.maxValue=neoplasmMax
		heatBar.currentValue=heat
		heatBar.maxValue=heatMax
		mrjBar.currentValue=mrj
		mrjBar.maxValue=mrjMax
		heat+=slag/slagMax*0.01
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
				var target=rad_to_deg(get_local_mouse_position().angle_to_point(Vector2.ZERO))-90
				texture.rotation_degrees += (
					target- texture.rotation_degrees
					) * animationSpeed;
				if abs(target- texture.rotation_degrees)<shootOffset*2:attackChecked()
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
		if superclocking:
			heat-=0.03
			mrj-=0.03
			if heat<=0 or mrj<=0:
				moveSpeedBoost-=superclockMovementSpeedBoost
				attackSpeed-=superclockAttackSpeedBoost
				attackDamage-=superclockAttackDamageBoost
				superclocking=false
	if enableAi&&init.isPlayerAlive:CustomAi()
	if (
		currentWeaponIndex>=0 and
		currentWeaponIndex<len(weapons) and
		Time.get_ticks_msec()-lastWeaponLaunchTime>=(
			weapons[currentWeaponIndex].shootingLimit
			if weapons[currentWeaponIndex].sustTimes>0
			else weaponLaunchLimit
		)/attackSpeed
	):
		var currentWeapon=weapons[currentWeaponIndex]
		var bullet=launchBullet(
			currentWeapon.bullet,
			currentWeapon,
			damageBoostFactor()
		)
		if currentWeapon.audioPlayer and sustIndex==0:
			currentWeapon.audioPlayer.pitch_scale=attackSpeed
			currentWeapon.audioPlayer.stream.set("loop", currentWeapon.loopSound)
			currentWeapon.audioPlayer.play()
		if currentWeapon.shootEffect and sustIndex==0:
			var cloned=currentWeapon.shootEffect.duplicate() as effectAuto
			cloned.bullet=bullet
			lastSustWeaponEffect=cloned
			if cloned.onWorld:
				cloned.global_position=global_position
				cloned.global_rotation=texture.global_rotation
			($/root/world if cloned.onWorld else currentWeapon).add_child(cloned)
		if currentWeapon.sustTimes>0:
			sustIndex+=1
			if sustIndex>=currentWeapon.sustTimes:
				sustIndex=0
				currentWeaponIndex+=1
				if playerControlled:userData.next()
				lastSustWeaponEffect.forceToEnd()
				currentWeapon.audioPlayer.stream.set("loop", false)
		else:
			currentWeaponIndex+=1
			if playerControlled:userData.next()
		lastWeaponLaunchTime=Time.get_ticks_msec()
func setLevel(newLevel):
	var healthRatio=health/healthMax
	level=newLevel
	healthMax=level*0.5*healthMaxSaved+healthMaxSaved
	health=healthRatio*healthMax
	attackDamage=level*0.05+attackDamageSaved
func readBullet(bullet:String):
	return get_node("/root/world/projectiles/"+bullet) as bulletAI
func weaponsConsume():
	var result=0
	for i in weapons:
		result+=i.thisWeaponConsume(attackLimit,attackSpeed)
	result/=1000.0
	return float(result)
func weaponsDamage():
	var result=0
	var willCritDamage;
	for i in weapons:
		result+=i.thisWeaponDamage(damageBoostFactor()+1)
	willCritDamage=result*critRate
	result-=willCritDamage
	willCritDamage*=critDamageBoost+1
	result+=willCritDamage
	return float(result)
func moveForward(force=600.0):
	apply_central_force(Vector2(
		sin(texture.rotation),
		-cos(texture.rotation)
	) * moveSpeed * force*(moveSpeedBoost+1))
func canAttack():
	return (
		(currentWeaponIndex==len(weapons) or currentWeaponIndex==-1) and
		(Time.get_ticks_msec()-lastAttackTime>attackLimit/attackSpeed)
		)
func launchBullet(bulletSubstance:bulletAI,spawner:Node2D,damageBooster:float=0):
	# print("launchBullet",bulletSubstance.name)
	var bullet=bulletSubstance.duplicate() as bulletAI
	bullet.position = spawner.global_position
	bullet.global_rotation_degrees = texture.global_rotation_degrees+randf_range(-shootOffset,shootOffset)
	bullet.enable=true
	bullet.launcher=self
	bullet.damageBooster=damageBooster
	bullet.damageFromPlayer=damageFromPlayer
	get_node("/root/world").add_child(bullet)
	return bullet
func overclock():
	print("overclock")
	if heat>=overclockNeedsHeat and mrj>=overclockNeedsMrj:
		print("success")
		heat-=overclockNeedsHeat
		mrj-=overclockNeedsMrj
		moveForward(overclockPushForce)
func superclock():
	print("superclock")
	if heat/heatMax>=superclockNeedsHeatPercent and mrj/mrjMax>=superclockNeedsMrjPercent:
		print("success")
		moveSpeedBoost+=superclockMovementSpeedBoost
		attackSpeed+=superclockAttackSpeedBoost
		attackDamage+=superclockAttackDamageBoost
		superclocking=true
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
func damageBoostFactor():
	return (slag/slagMax*0.5*(oil/oilMax) if
		weapons[currentWeaponIndex-(0 if currentWeaponIndex<len(weapons) else 1)].bullet.myDamageType==damageType.Enums.HIGH_T else
		0.0)+(attackDamage-1)
func hit(damage:int,crit:bool,damageBoost:float,myDamageType:damageType.Enums):
	if randf_range(0,1)<evasion:
		return
	if not playerControlled:
		damageNode.dps+=damage
	animator.play("hit")
	health -= damage
	if myDamageType==damageType.Enums.BIOEROSION:
		mrj+=damage
	if myDamageType==damageType.Enums.HIGH_T:
		heat+=damage*0.1
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
			panelDefine.checkTo("gameover")
			init.isPlayerAlive=false
			healthBar.currentValue=0
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
