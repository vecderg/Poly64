extends Node

@export var workCart := "==POLY64 CARTRIDGE==\r\n=CODE=\r\n=CODE=\r\n=MODEL=\r\n=MODEL=\r\n=TEXTURE=\r\n=TEXTURE=\r\n=AUDIO=\r\n=AUDIO=\r\n==POLY64 CARTRIDGE=="
var cartridgeDir := "res://cartridge.txt"
var workCode := ""

@onready var codeWindow = $"Code"
@onready var textureWindow = $"Texture"
@onready var modelWindow = $"Model"

func _ready():
	#cartridgeDir = OS.get_executable_path().get_base_dir().path_join("cartridge.txt")
	#loadCartridge(cartridgeDir)
	pass

## Loading cartridge from P64 text file
func loadCartridge(newDir):
	cartridgeDir = newDir
	var file
	## Rare exception
	if !FileAccess.file_exists(cartridgeDir):
		text(10,150,"FILE DOESN'T EXIST",5)
	else:
		file = FileAccess.open(cartridgeDir,FileAccess.READ)
		var firstLine = file.get_line()
		## Load in the actual data
		if firstLine == "==POLY64 CARTRIDGE==":
			workCart = file.get_as_text()
			text(0,150,"LOADED " + newDir,5,8)
			setWorkCode()
			codeWindow.loadCartridge()
			textureWindow.loadCartridge()
		## Throw exception if not actual data
		else:
			print(firstLine)
			text(10,150,"FILE NOT CARTRIDGE",3)
	file = null #method for closing file

## Saving cartridge to P64 text file
func saveCartridge(newDir):
	cartridgeDir = newDir
	var file = FileAccess.open(cartridgeDir,FileAccess.WRITE)
	file.seek(0)
	formatData()
	file.store_string(workCart)
	file = null
	text(0,150,"SAVED " + newDir,5,8)

## Formatting save data to a readable P64 text file
func formatData() -> String : 
	textureWindow.formatData()
	
	workCart = "==POLY64 CARTRIDGE==\n=CODE=\n"
	workCart += workCode + "\n=CODE=\n"
	workCart += "=MODEL=\n"
	workCart += "=MODEL=\n"
	workCart += "=TEXTURE=\n"
	workCart += str(textureWindow.textureArray)
	workCart += "\n=TEXTURE=\n=AUDIO=\n=AUDIO=\n==POLY64 CARTRIDGE=="
	return workCart

func _process(_delta):
	pass

func activateBootMenu():
	for node in get_children():
		node.visible = false
	get_node("Menu").visible = true

## Switching between menus
func activate(oldMenu, newMenu):
	if get_node(newMenu) != null:
		get_node(oldMenu).visible = false
		get_node(newMenu).visible = true

## Function for printing things to screen
func text(posX:float, posY:float, printText:String, printTime=1, fontSize=8, textWrap=true):
	var newPrint = CanvasLayer.new()
	var textLabel = Label.new()
	newPrint.add_child(textLabel)
	newPrint.set_script(load("res://Scripts/Print.gd"))
	newPrint.create(printTime, printText)
	add_child(newPrint)
	textLabel.position = Vector2(posX,posY)
	textLabel.add_theme_font_size_override("font_size",fontSize)
	if textWrap:
		textLabel.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
		## Makes the text wrap at the end of the screen
		textLabel.size = Vector2(240 - textLabel.position.x,180)
	return newPrint.get_child(0)
	
static func pressed(button:String):
	return Input.is_action_pressed(button)

static func justPressed(button:String):
	return Input.is_action_just_pressed(button)
	
func setWorkCode():
	workCode = workCart.split("=CODE=")[1].strip_edges()
	print(workCart.split("==POLY64 CARTRIDGE=="))


