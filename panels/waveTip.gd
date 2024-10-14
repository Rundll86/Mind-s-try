extends panelDefine
func onOpen():
    print("wave tip opened")
    get_node("bar/title/show/title-C").text = str(init.wave + 1)
    init.isSelectingBuff = true
    init.resetBuffCostSaved = $/root/world.resetBuffCost
    init.generateBuffCard()
    get_node("bar/buffs/animator").play("show")
func onClose():
    print("wave tip closed")
    init.isSelectingBuff = false