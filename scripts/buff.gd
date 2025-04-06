extends Node;
class_name buff;
@export var displayName = "未知增益";
@export var texture: Texture2D;
@export var healthMax: float = 60;
@export var attackSpeed: float = 0;
@export var attackDamage: float = 0;
@export var movementSpeed: float = 0;
@export var critRate: float = 0;
@export var critDamage: float = 0;
@export var evasion: float = 0;
@export var costItems: Array[item] = [];
@export var costCounts: Array[int] = [];
@export var coolant: float = 0;
@export var oil: float = 0;
@export var slag: float = 0;
@export var addWeapon: Weapon = null;
@export var bulletBoost: int = 0;
@export var shootOffset: float = 0;
static var collections: Array[buff] = [];
