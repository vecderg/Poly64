extends Button

@onready var textureNode = get_node("../../../../../..")
@onready var thumbnailLabel = get_node("..")

func _on_button_down():
	#print(int(str(thumbnailLabel.text)) + 1)
	textureNode.setTexture(int(str(thumbnailLabel.text)) + 1)
	pass # Replace with function body.
