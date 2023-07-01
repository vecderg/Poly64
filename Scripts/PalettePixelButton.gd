extends TouchScreenButton

@onready var textureNode = get_node("../../../../..")

func _ready():
	#z_index = 100
	pass

func _on_pressed():
	textureNode.currentColor = get_node("..").color
	textureNode.colorPaletteBG.visible = false
