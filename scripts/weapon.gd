extends Node2D
class_name Weapon
var audioPlayer: AudioStreamPlayer2D;
@export var bullet: bulletAI;
@export var shootEffect: effectAuto;
@export var displayName = "未知武器";
@export var icon: Texture2D;
@export var sustTimes: int = 0;
@export var shootingLimit: float = 0;
@export var loopSound: bool = false;
@export var audioAcceleration:bool=false;
func _ready():
	audioPlayer = get_node_or_null("asp")
	if audioPlayer and sustTimes > 0:
		audioPlayer.stream = audioPlayer.stream.duplicate()
	if shootEffect:
		shootEffect = shootEffect.duplicate() as effectAuto
		shootEffect.one_shot = true
		shootEffect.emitting = false
func thisWeaponConsume(playerLimit: float, playerSpeed: float):
	if sustTimes > 0:
		return ((sustTimes - 1) * shootingLimit + playerLimit) / playerSpeed
	else:
		return playerLimit / playerSpeed
func thisWeaponDamage(playerDamage: float):
	if sustTimes > 0:
		return sustTimes * bullet.damage * playerDamage
	else:
		return bullet.damage * playerDamage
