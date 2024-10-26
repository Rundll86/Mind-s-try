extends Node2D
class_name waveDefine
@export var target: entity;
@export var rateBoost: float = 0;
@export var maxCount: int = 10;
@export var spawnAsBoss: bool = false;
@export var fromWave: int = 1; # 从第一波到以后无限波
@export var toWave: int = -1; # 无限
@export var spawnRandomPosition: Vector2 = Vector2(500, 500);
@export var perWaves:int=1; # 每一波生成一次
