extends Control

@onready var C = $".."

@onready var loadPopup = $"LoadFile"
@onready var savePopup = $"SaveFile"

func _ready():
	pass 

func _process(_delta):
	pass

func _on_button_pressed():
	loadPopup.popup()
	pass 

func _on_load_file_file_selected(path):
	C.loadCartridge(path)
	pass 

func _on_save_button_pressed():
	savePopup.popup()
	pass 

func _on_save_file_file_selected(path):
	C.saveCartridge(path)
	pass 

func _on_back_button_pressed():
	C.activate("Load","Menu")
	pass



