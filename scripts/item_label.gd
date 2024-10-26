extends HBoxContainer
class_name itemLabel
@export var itemTexture:Texture2D;
@export var count:int=0;
var itemAvatar:TextureRect;
var itemCount:Label;
func _ready():
	itemAvatar=$avatar
	itemCount=$count
func _process(_delta: float):
	itemAvatar.texture=itemTexture
	itemCount.text=str(count)
