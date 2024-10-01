extends Node
class_name waveDefine
@export var target: entity;
@export var rateBoost: float = 0;
@export var maxCount: int = 10;
@export var spawnAsBoss: bool = false;
@export var fromWave: int = 1; # 从第一波到以后无限波
@export var toWave: int = -1; # 无限
@export var enable: bool = true;
@export var spawnRandomPosition: Vector2 = Vector2(500, 500);