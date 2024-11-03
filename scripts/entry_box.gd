extends HBoxContainer;
class_name entryBox;
enum EntryUnit {NONE, DEGRESS, PERCENT,TEXT};
var unitToTextMap = {
	EntryUnit.NONE: "",
	EntryUnit.DEGRESS: "°",
	EntryUnit.PERCENT: "%",
	EntryUnit.TEXT:""
};
var nameLabel: Label;
var valueLabel: Label;
var unitLabel: Label;
@export var entryName: String = "生命值上限";
var entryValue;
@export var entryUnit: EntryUnit = EntryUnit.NONE;
func _ready():
	nameLabel = get_node("name")
	valueLabel = get_node("value/text")
	unitLabel = get_node("value/unit")
func _process(_delta):
	nameLabel.text = entryName
	valueLabel.text = (
		entryValue
		if entryUnit==EntryUnit.TEXT
		else
		"%.1f"%(entryValue * (100 if entryUnit == EntryUnit.PERCENT else 1))
	)
	unitLabel.text = unitToTextMap[entryUnit]
