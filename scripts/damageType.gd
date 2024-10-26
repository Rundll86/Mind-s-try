extends Node
class_name damageType
@export var EnumsHIGH_T=Color(1, 0.492, 0);
@export var EnumsLOW_T=Color(0.641, 1, 1);
@export var EnumsCOLLITE=Color(1, 1, 1);
@export var EnumsOVERLOADED=Color(0.271, 0.266, 1);
@export var EnumsSOFTWARE=Color(0, 0.758, 0.047);
@export var EnumsBIOEROSION=Color(1, 0, 0);
@export var EnumsTHUNDER=Color(1, 0.927, 0.453);
@export var EnumsMAGIC=Color(0.929, 0.529, 0.929);
static var colorMapper = {}
enum Enums {
	HIGH_T,
	LOW_T,
	COLLITE,
	OVERLOADED,
	SOFTWARE,
	BIOEROSION,
	THUNDER,
	MAGIC
}
func _ready():
	colorMapper[Enums.HIGH_T] = EnumsHIGH_T
	colorMapper[Enums.LOW_T] = EnumsLOW_T
	colorMapper[Enums.COLLITE] = EnumsCOLLITE
	colorMapper[Enums.OVERLOADED] = EnumsOVERLOADED
	colorMapper[Enums.SOFTWARE] = EnumsSOFTWARE
	colorMapper[Enums.BIOEROSION] = EnumsBIOEROSION
	colorMapper[Enums.THUNDER] = EnumsTHUNDER
	colorMapper[Enums.MAGIC] = EnumsMAGIC
