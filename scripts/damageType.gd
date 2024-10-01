extends Object
class_name damageType
static var colorMapper = {
    Enums.HIGH_T: Color(1, 0.492, 0),
    Enums.LOW_T: Color(0.641, 1, 1),
    Enums.COLLITE: Color(1, 1, 1),
    Enums.OVERLOADED: Color(0.761, 0.543, 1),
    Enums.SOFTWARE: Color(0, 0.758, 0.047),
    Enums.BIOEROSION: Color(1, 0, 0),
    Enums.THUNDER: Color(1, 0.927, 0.453),
    Enums.MAGIC: Color(0.929, 0.529, 0.929)
}
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