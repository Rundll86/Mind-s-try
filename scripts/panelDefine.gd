extends CanvasItem
class_name panelDefine

func onOpen():
    pass
func onClose():
    pass

func _ready():
    panelRoot = $"/root/world/camera/ui-show/panels"
    panelBackground = panelRoot.get_node("bg")
    panelRootAnimator = panelRoot.get_node("animator")
    currentPanel = null
    panelRoot.hide()
    panelRootAnimator.animation_finished.connect(onAnimationFinished)
    for i in panelBackground.get_children():
        i.hide()
func onAnimationFinished(anim_name):
    if anim_name == "hide":
        if currentPanel:
            currentPanel.hide()
            panelRoot.hide()
        currentPanel = null
        if willCheckTo:
            panelRoot.show()
            currentPanel = willCheckTo
            currentPanel.show()
            panelRootAnimator.play("show")

static var panelRoot: Node2D;
static var panelBackground: Panel;
static var panelRootAnimator: AnimationPlayer;
static var currentPanel: panelDefine;
static var willCheckTo: panelDefine;

static func findPanel(panel) -> panelDefine:
    return panelBackground.get_node_or_null(panel) as panelDefine
static func checkTo(panel):
    willCheckTo = findPanel(panel)
    if willCheckTo:
        willCheckTo.onOpen()
        if currentPanel:
            currentPanel.onClose()
            panelRootAnimator.play("hide")
        else:
            panelRoot.show()
            currentPanel = willCheckTo
            currentPanel.show()
            panelRootAnimator.play("show")
static func closeCurrent():
    willCheckTo = null
    currentPanel.onClose()
    panelRootAnimator.play("hide")