extends Button

@onready var textureNode = get_node("../../../../..")

func _ready():
	#z_index = 100
	pass

func _process(_delta):
	if visible:
		if is_hovered() && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_on_pressed()

func _on_pressed():
	if textureNode.menuOpen:
		textureNode.closeMenus()
		pass
	else:
		get_node("..").color = textureNode.currentColor
	
