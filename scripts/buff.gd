extends Node;
class_name buff;
@export var displayName = "未知增益";
@export var texture: Texture2D;
@export var healthMax = 60
@export var attackSpeed = 0
@export var attackDamage = 0
@export var movementSpeed = 0
@export var critRate = 0
@export var critDamage = 0
@export var evasion = 0
static var collections: Array[buff] = [];