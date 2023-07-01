extends Node

class_name P64

## Static function for printing things to screen. targetNode is required because it's static.
static func print(posX:float, posY:float, printText:String, targetNode:Node, printTime=1, fontSize=8, textWrap=true):
	var newPrint = CanvasLayer.new()
	var textLabel = Label.new()
	newPrint.add_child(textLabel)
	newPrint.set_script(load("res://Scripts/Print.gd"))
	newPrint.create(printTime, printText)
	targetNode.add_child(newPrint)
	textLabel.position = Vector2(posX,posY)
	textLabel.add_theme_font_size_override("font_size",fontSize)
	if textWrap:
		textLabel.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
		#Makes the text wrap at the end of the screen
		textLabel.size = Vector2(240 - textLabel.position.x,180)
	return newPrint.get_child(0)
	
static func pressed(button:String):
	return Input.is_action_pressed(button)

static func justPressed(button:String):
	return Input.is_action_just_pressed(button)
