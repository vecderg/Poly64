extends Node

@onready var C = $".."
@onready var textEdit = $"Panel/TextEdit"
@onready var lineCount = $"Panel/LineCount"

func _ready():
	loadCartridge()

func _process(_delta):
	if self.visible:

		pass
	pass

func loadCartridge():
	#textEdit.text = C.workCode
	pass

func _on_back_button_pressed():
	C.activate("Code","Menu")
	pass # Replace with function body.
