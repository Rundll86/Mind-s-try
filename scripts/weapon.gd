extends Node2D
class_name Weapon
var audioPlayer: AudioStreamPlayer2D;
@export var bullet: bulletAI;
@export var shootEffect: effectAuto;
@export var displayName = "未知武器";
@export var icon: Texture2D;
@export var sustTimes: int = 0;
@export var shootingLimit: float = 0;
func _ready():
	audioPlayer = get_node_or_null("asp")
	if shootEffect:
		shootEffect = shootEffect.duplicate() as effectAuto
		shootEffect.one_shot = true
		shootEffect.emitting = false
