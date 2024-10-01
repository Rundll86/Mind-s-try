extends Node2D
class_name weapon
var audioPlayer: AudioStreamPlayer2D;
@export var bullet: bulletAI;
@export var shootEffect: effectAuto;
@export var displayName = "未知武器";
@export var icon: Texture2D;
func _ready():
    audioPlayer = $asp
    if shootEffect:
        shootEffect = shootEffect.duplicate() as effectAuto
        shootEffect.one_shot = true
        shootEffect.emitting = false