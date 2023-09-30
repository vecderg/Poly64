extends Node

@onready var C = $".."

var running = false
var code = ""
var splitCode
var variables = []

var readyFunc 
var processFunc
var drawFunc

var sysFunctions = ["print","boogie","sprite"]

func _ready():
	pass 

func runGame():
	code = C.workCode ## Set code
	variables = [] ## Reset variables 
	splitCode = code.split("\n") ## Cut up code by lines
	#print(splitCode)
	C.textureWindow.formatData() ## Reload the textures in case it hasn't been saved
	parseFuncs()
	#print(readyFunc)
	if readyFunc != null:
		runCode(readyFunc)
	running = true
	pass
	
func parseFuncs():
	var i = 0
	for line in splitCode:
		if line.begins_with("func"):
			if line == "func _ready():":
				readyFunc = getIndentedLines(i + 1,splitCode)
			elif line == "func _process():":
				processFunc = getIndentedLines(i + 1,splitCode)
			elif line == "func _draw():":
				drawFunc = getIndentedLines(i + 1,splitCode)
		i+=1
	#print(readyFunc)
	#print(processFunc)
	#print(drawFunc)

## Mainly to store functions into one lil variable
func getIndentedLines(firstIndex, splitLines):
	var funcEndLine = firstIndex - 1
	for i in range(firstIndex,splitLines.size()):
		## Keep updating funcEndLine so that it's equal to i
		## in case the end of the script is the end of the function
		funcEndLine = i
		## Missing an indent means end of function
		if !splitCode[i].begins_with("\t"):
			funcEndLine = i
			break
	## If no function, funcEndLine would be firstIndex - 1
	if funcEndLine < firstIndex:
		throwError("Function not implemented")
		return -1
	## Return all the indented lines
	var returnLines = []
	for i in range(firstIndex, funcEndLine+1):
		returnLines.append(splitLines[i])
		print(firstIndex)
	
	return returnLines

func runCode(splitLines):
	for line in splitLines:
		## Flips through all built-in functions and checks for a match
		## Yes, this is probably the least optimal way to do this
		for function in sysFunctions:
			# If a function matches, call it
			if line.begins_with("\t" + function + "(") && line.ends_with(")"):
				var callable = Callable(self,"p" + function)
				
				## Call it with the argument if it has one, or not if not
				## Does NOT account for multiple arguments
				if line.get_slice("(",1).left(-1).length() > 0:
					callable.call(line.get_slice("(",1).left(-1))
				else:
					callable.call()
			else:
				#print(line.begins_with("\t" + function + "("))
				pass

func throwError(errorText):
	endGame()
	#P64.print(20,150,errorText,get_node(".."),5)
	C.text(0,150,errorText,5,8)
	print(errorText)
	C.activateBootMenu()

func clearChildren():
	for child in get_children():
		child.queue_free()

func endGame():
	running = false
	clearChildren()

func _process(delta):
	## For universal run shortcut
	if Input.is_action_just_pressed("Run"):
		C.activate("Any","Run")
		runGame()
	
	## Run process function
	if running && processFunc != null:
		runCode(processFunc)
		pass
	pass

## Function for printing to screen
func pprint(string, x=10, y=10, time=5):
	C.text(x,y,string,time)

## Testing function for function reading
func pboogie():
	#print("wah")
	C.text(0,150,"TIME TO BOOGAAAYYY",0.1)
	#C.rotation_degrees += 180
	
## Function for drawing sprites
func psprite(ID):
	ID = int(ID)
	## Throw error if sprite index is OOB
	if ID >= C.textureWindow.textureArray.size() || ID < 0:
		throwError("SPRITE INDEX OUT OF BOUNDS")
		return null
		
	var data = C.textureWindow.textureArray[ID]
	var imgWidth = sqrt(data.size())
	
	var newImage = Image.create(imgWidth, imgWidth, false, Image.FORMAT_RGBA8)
	
	## Sets pixel color to ID in textureArray based on colorPaletteArray
	## Since it's a 1D array, it needs a nested for loop + math 
	## to create a "2D array"
	for i in range(imgWidth):
		for j in range(imgWidth):
			
			newImage.set_pixel(i,j,(C.textureWindow.colorPaletteArr[data[i+imgWidth*j]]))
	
	var newCanvas = CanvasLayer.new()
	var texRect = TextureRect.new()
	newCanvas.add_child(texRect)
	texRect.texture = ImageTexture.create_from_image(newImage)
	newCanvas.set_script(load("res://Scripts/Sprite.gd"))
	newCanvas.create(5)
	add_child(newCanvas)
	
	#newImage.save_png("res://Sprite.png") ## Saves as png. Helpful for testing

	

