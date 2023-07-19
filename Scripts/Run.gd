extends Node

@onready var C = $".."

var running = false
var code = ""
var splitCode
var variables = []

var readyFunc 
var processFunc
var drawFunc

func _ready():
	pass 

func runGame():
	#C.text(10,150,"RUNNING",5)
	code = C.workCode
	splitCode = code.split("\n")
	print(splitCode)
	parseFuncs()
	print(readyFunc)
	runCode(readyFunc)
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

# Mainly to store functions into one lil variable
func getIndentedLines(firstIndex, splitLines):
	var funcEndLine = firstIndex - 1
	for i in range(firstIndex,splitLines.size()):
		# Keep updating funcEndLine so that it's equal to i
		# in case the end of the script is the end of the function
		funcEndLine = i
		# Missing an indent means end of function
		if !splitCode[i].begins_with("\t"):
			funcEndLine = i
			break
	# If no function, funcEndLine would be firstIndex - 1
	if funcEndLine < firstIndex:
		throwError("Function not implemented")
		return -1
	# Return all the indented lines
	var returnLines = []
	for i in range(firstIndex, funcEndLine+1):
		returnLines.append(splitLines[i])
		print(firstIndex)
	
	return returnLines

func runCode(splitLines):
	for line in splitLines:
		if line.begins_with("\tprint("):
			# print's whatever's after the parentheses
			C.text(10,150,line.get_slice("(",1).left(-1),5)
			print(line.get_slice("(",1).left(-1))
		else:
			print(line)

func throwError(errorText):
	running = false
	#P64.print(20,150,errorText,get_node(".."),5)
	C.text(10,150,errorText,5)
	C.activateBootMenu()

func _process(delta):
	if running:
		
		pass
	pass
