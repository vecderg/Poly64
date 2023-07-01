extends Control

@onready var C = $".."
@onready var paletteNode := $"Panel/ColorPaletteBG/ColorPalette"
@onready var curColorNode := $"Panel/CurrentColor"
@onready var textureContainer = $"Panel/TextureScroll/TextureContainer"
@onready var createTextureDialog = $"Panel/CreateTextureDialog"
@onready var drawCanvas = $"Panel/DrawPanel/DrawCanvas"
@onready var scaleSlider = $"Panel/ScaleSlider"
@onready var xSlider = $"Panel/XSlider"
@onready var ySlider = $"Panel/YSlider"
@onready var brushSlider = $"Panel/BrushSlider"
@onready var colorPaletteBG = $"Panel/ColorPaletteBG"
@onready var pixelButton = preload("res://Prefabs/PixelButton.tscn")
@onready var palettePixelButton = preload("res://Prefabs/PalettePixelButton.tscn")
@onready var thumbnailButton = preload("res://Prefabs/ThumbnailButton.tscn")
var colorPalette : Array[Color]
var currentColor := Color.WHITE
var menuOpen := false ## Checks if any menu is open, which disables drawing

var paletteIndex := 0
var currentThumbnail = null

var textureArray = [[]] ## Array of textures in text file data format

var colorPaletteArr = [
	Color.TRANSPARENT,
	Color.BLACK,
	Color.html("202020"),
	Color.html("404040"),
	Color.html("606060"),
	Color.html("808080"),
	Color.html("a0a0a0"),
	Color.html("c0c0c0"),
	Color.html("e0e0e0"),
	Color.html("ffffff"),
	Color.CORAL,
	Color.FIREBRICK,
	Color.html("300909"),
	Color.DARK_RED,
	Color.RED,
	Color.ORANGE_RED,
	Color.DARK_ORANGE,
	Color.ORANGE,
	Color.CHOCOLATE,
	Color.GOLD,
	Color.YELLOW,
	Color.KHAKI,
	Color.MOCCASIN,
	Color.PALE_GREEN,
	Color.SPRING_GREEN,
	Color.GREEN_YELLOW,
	Color.CHARTREUSE,
	Color.OLIVE_DRAB,
	Color.OLIVE,
	Color.MEDIUM_AQUAMARINE,
	Color.AQUAMARINE,
	Color.CYAN,
	Color.DARK_CYAN,
	Color.SKY_BLUE,
	Color.DEEP_SKY_BLUE,
	Color.ROYAL_BLUE,
	Color.MIDNIGHT_BLUE,
	Color.NAVY_BLUE,
	Color.INDIGO,
	Color.WEB_PURPLE,
	Color.PURPLE,
	Color.REBECCA_PURPLE,
	Color.MEDIUM_ORCHID,
	Color.FUCHSIA,
	Color.HOT_PINK,
	Color.VIOLET,
	Color.PLUM,
	Color.CRIMSON,
	Color.MAROON,
	Color.PINK
]

func _ready():
	for index in range(paletteNode.get_child_count()):
		colorPalette.append(paletteNode.get_child(index).color)
	#print(colorPalette)
	for color in colorPaletteArr:
		if color != Color.TRANSPARENT:
			var newRect = ColorRect.new()
			newRect.custom_minimum_size = Vector2(8,8)
			newRect.color = color
			paletteNode.add_child(newRect)
			var newButton = palettePixelButton.instantiate()
			newButton.shape.size = newRect.size
			newButton.position = Vector2(newRect.size.x/2, newRect.size.y/2)
			newRect.add_child(newButton)
	pass

func _process(_delta):
	
	if self.visible:
		curColorNode.color = currentColor
		#print(drawCanvas.get_class())
		drawCanvas.scale = Vector2(scaleSlider.value,scaleSlider.value)
		drawCanvas.position = Vector2(xSlider.value,ySlider.value)
		
		menuOpen = colorPaletteBG.visible || createTextureDialog.visible
		
		## Match thumbnail colors to palette
		if currentThumbnail != null:
			paletteIndex = int(str(currentThumbnail.name))
			for i in range(currentThumbnail.get_child_count()):
				currentThumbnail.get_child(i).color = drawCanvas.get_child(i).color
		
		#print(get_local_mouse_position() - colorPaletteBG.position)
	pass

func closeMenus():
	createTextureDialog.visible = false
	colorPaletteBG.visible = false


func loadCartridge(): ## Turns text data to textures
	## Clears current canvas and thumbnails for clean slate
	for child in drawCanvas.get_children():
		child.queue_free()
	currentThumbnail = null
	paletteIndex = 0
	for container in textureContainer.get_children():
		if container.name != "NewTexture":
			container.queue_free()
	## Gets texture data from workCart
	var textureRaw = C.workCart.split("=TEXTURE=")[1].strip_edges()
	textureRaw = textureRaw.replace("[","]")
	textureRaw = textureRaw.split("]")
	## Removes garbage, aka leftover spaces and commas
	var newTextureRaw = []
	for array in textureRaw:
		if !(array.length() < 3):
			newTextureRaw.append(array)
	textureRaw = newTextureRaw
	
	## Convert strings to string arrays
	## aka instead of ["1,2","3,4"] it's [["1","2"],["3","4"]]
	newTextureRaw = []
	for array in textureRaw:
		newTextureRaw.append(array.split(", "))
	textureRaw = newTextureRaw

	## Create texture thumbnails using a reworked version of the earlier thumbnail code
	var tnIndex = 0
	for array in textureRaw:
		## Populate thumbnail with pixels based on texture size
		var thumbnail = GridContainer.new()
		thumbnail.columns = sqrt(array.size())
		var newRect 
		for index in range(array.size()):
			newRect = ColorRect.new()
			newRect.custom_minimum_size = Vector2(1,1)
			newRect.color = colorPaletteArr[int(array[index])]
			thumbnail.add_child(newRect)
		thumbnail.add_theme_constant_override("h_separation",0)
		thumbnail.add_theme_constant_override("v_separation",0)
		## Add thumbnail with label to sidebar
		var thumbnailContainer = HBoxContainer.new()
		var thumbnailLabel = Label.new()
		#thumbnailLabel.text = str(textureContainer.get_child_count() - 1)
		thumbnailLabel.text = str(tnIndex) ## Replaced because queue_free() child problem
		thumbnailLabel.add_theme_font_size_override("font_size",8)
		thumbnailContainer.add_child(thumbnail)
		thumbnailContainer.add_child(thumbnailLabel)
		textureContainer.add_child(thumbnailContainer)
		thumbnail.name = thumbnailLabel.text
		thumbnailContainer.set_layout_direction(3)
		thumbnailContainer.custom_minimum_size = Vector2(thumbnailContainer.get_node("..").size.x,30)
		thumbnail.custom_minimum_size = Vector2(35,30)
		thumbnail.set_layout_direction(2)
		## Make thumbnails clickable
		var newThumbnailButton = thumbnailButton.instantiate()
		newThumbnailButton.size = thumbnailLabel.size + Vector2(40,20)
		newThumbnailButton.position += Vector2(-40,-10)
		thumbnailLabel.add_child(newThumbnailButton)
		tnIndex += 1 ## Add index for thumbnail label count
	pass


func _on_back_button_pressed():
	C.activate("Texture","Menu")
	pass

func _on_new_texture_pressed():
	createTextureDialog.visible = !createTextureDialog.visible

func _on_CreateTexture_pressed(textureSize : int):
	#print(textureSize)
	closeMenus()
	createTextureDialog.visible = false
	#print("clicked")
	createTexture(textureSize)
	pass

## For clicking a thumbnail to edit it
func setTexture(index):
	_on_reset_pos_pressed()
	currentThumbnail = textureContainer.get_child(index).get_child(0)
	## Clear drawCanvas
	for child in drawCanvas.get_children():
		child.queue_free()
	## Populate canvas with pixels based on texture size
	drawCanvas.columns = currentThumbnail.columns
	var sizeLength = (drawCanvas.size.x / drawCanvas.columns) - 1
	var newRect 
	for i in range(currentThumbnail.get_child_count()):
		newRect = ColorRect.new()
		newRect.custom_minimum_size = Vector2(sizeLength,sizeLength)
		newRect.color = currentThumbnail.get_child(i).color
		drawCanvas.add_child(newRect)
	## Make drawCanvas pixels clickable
	for child in drawCanvas.get_children():
		var newButton = pixelButton.instantiate()
		#newButton.shape.size = child.size
		newButton.size = child.size
		#newButton.position = Vector2(child.size.x/2, child.size.y/2)
		child.add_child(newButton)
	pass

func createTexture(textureSize):
	## Clear drawCanvas
	for child in drawCanvas.get_children():
		child.queue_free()
	## Populate canvas with pixels based on texture size
	drawCanvas.columns = textureSize
	var newRect 
	var sizeLength = (drawCanvas.size.x / textureSize) - 1 #to account for separation
	for index in range(textureSize*textureSize):
		newRect = ColorRect.new()
		newRect.custom_minimum_size = Vector2(sizeLength,sizeLength)
		newRect.color = Color.BLACK
		drawCanvas.add_child(newRect)
	## Create thumbnail for sidebar
	var thumbnail = drawCanvas.duplicate(8)
	thumbnail.add_theme_constant_override("h_separation",0)
	thumbnail.add_theme_constant_override("v_separation",0)
	for index in range(thumbnail.get_child_count()):
		if drawCanvas.get_child(index).is_queued_for_deletion():
			thumbnail.get_child(index).queue_free()
		else:
			thumbnail.get_child(index).custom_minimum_size = Vector2(1,1)
	var thumbnailContainer = HBoxContainer.new()
	## Add thumbnail with label to sidebar
	var thumbnailLabel = Label.new()
	thumbnailLabel.text = str(textureContainer.get_child_count() - 1)
	#print(textureContainer.get_child_count())
	thumbnailLabel.add_theme_font_size_override("font_size",8)
	thumbnailContainer.add_child(thumbnail)
	thumbnailContainer.add_child(thumbnailLabel)
	textureContainer.add_child(thumbnailContainer)
	thumbnail.name = thumbnailLabel.text
	thumbnailContainer.set_layout_direction(3)
	thumbnailContainer.custom_minimum_size = Vector2(thumbnailContainer.get_node("..").size.x,30)
	thumbnail.custom_minimum_size = Vector2(35,30)
	thumbnail.set_layout_direction(2)
	currentThumbnail = thumbnail
	## Make thumbnails clickable
	var newThumbnailButton = thumbnailButton.instantiate()
	newThumbnailButton.size = thumbnailLabel.size + Vector2(40,20)
	newThumbnailButton.position += Vector2(-40,-10)
	thumbnailLabel.add_child(newThumbnailButton)
	
	## Make drawCanvas pixels clickable
	for child in drawCanvas.get_children():
		var newButton = pixelButton.instantiate()
		#newButton.shape.size = child.size
		newButton.size = child.size
		#newButton.position = Vector2(child.size.x/2, child.size.y/2)
		child.add_child(newButton)
	pass

func formatData(): ## Formats the textures into text file data
	textureArray = []
	var index = 0
	## Loop through the textureContainer
	for thumbnailContainer in textureContainer.get_children():
		if thumbnailContainer.name != "NewTexture":
			var newTexture = []
			## Loop through the actual thumbnails, AKA child 1 and take their colors
			for i in range(textureContainer.get_child(index).get_child(0).get_child_count()):
				newTexture.append(colorToIndex(textureContainer.get_child(index).get_child(0).get_child(i).color))
			textureArray.append(newTexture)
		index += 1

func colorToIndex(checkColor):
	for index in colorPaletteArr.size():
		if checkColor == colorPaletteArr[index]:
			return index
	return 1

func _on_reset_pos_pressed():
	xSlider.value = 1
	ySlider.value = 1
	scaleSlider.value = 1
	pass # Replace with function body.

func _on_palette_button_pressed():
	colorPaletteBG.visible = !colorPaletteBG.visible
	pass # Replace with function body.

func _on_brush_slider_drag_ended(value_changed):
	print("oop")
	pass # Replace with function body.
