extends PanelContainer
class_name valuebar;
@export var maxValue: float = 100;
@export var minValue: float = 0;
@export var currentValue: float = 50;
@export var animationSpeedFront: float = 0.6;
@export var animationSpeedBack: float = 0.01;
@export var colorFront: Color = Color(1, 1, 1);
@export var colorBack: Color = Color(1, 0.455, 0.439);
@export var haveSkew: bool = true;
var frontBar: ProgressBar;
var backBar: ProgressBar;
var frontStyleBox: StyleBoxFlat;
var backStyleBox: StyleBoxFlat;
func _ready():
    frontBar = $front
    backBar = $back
    frontStyleBox = frontBar.get_theme_stylebox("fill").duplicate()
    backStyleBox = backBar.get_theme_stylebox("fill").duplicate()
    #样式
    frontStyleBox.bg_color = colorFront
    backStyleBox.bg_color = colorBack
    frontStyleBox.skew.x = 0.4 if haveSkew else 0.0
    backStyleBox.skew.x = 0.4 if haveSkew else 0.0
    frontBar.add_theme_stylebox_override("fill", frontStyleBox)
    backBar.add_theme_stylebox_override("fill", backStyleBox)
func _process(_delta):
    #常量
    frontBar.max_value = maxValue
    frontBar.min_value = minValue
    backBar.max_value = maxValue
    backBar.min_value = minValue
    #变量
    frontBar.value += (currentValue - frontBar.value) * animationSpeedFront
    backBar.value += (currentValue - backBar.value) * animationSpeedBack