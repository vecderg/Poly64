extends Node3D

@onready var C = $".."

@onready var introPlayer := $"IntroPlayer"
@onready var optionPlayer := $"OptionPlayer"
@onready var cube := $"Cube"
@onready var canvas := $"CanvasLayer"
@onready var scroller := $"CanvasLayer/UI/ScrollContainer"
@onready var timer := $"Timer"
@onready var soundStartup := $"SoundStartup"
@onready var soundTick := $"SoundTick"
@onready var soundSelect := $"SoundSelect"


var scrollDistances := [35,50,65,80,94,109]
var scrollAnimations := ["Run","Load","Code","Model","Texture","Audio"]
var scrollIndex := 1
var introDone := false
var startTime := 2.5

func _ready():
	intro()
	pass 

func intro():
	if self.visible:
		soundStartup.play()
		introPlayer.play("Intro")
		setMenuVisual(1)
		timer.start(startTime)

func _process(_delta):
	#if Input.is_key_pressed(KEY_R):
	#	get_tree().reload_current_scene()
	
	canvas.visible = self.visible
	
	if P64.justPressed("Escape"):
		C.activateBootMenu()
		C.runWindow.endGame()
	
	if self.visible:
		self.visible = true
		if P64.justPressed("2"):
			#intro()
			pass
		# skip intro sequence
		if (P64.justPressed("1") || P64.justPressed("3")) || Input.is_mouse_button_pressed(1) && !introDone:
			introPlayer.speed_scale = 100
			timer.stop()
			soundStartup.stop()
			
		if introDone:
			if P64.justPressed("Down"):
				setMenuVisual((scrollIndex+1) % scrollAnimations.size())
				soundTick.play()
			elif P64.justPressed("Up"):
				setMenuVisual((scrollIndex-1) % scrollAnimations.size())
				soundTick.play()
			elif P64.justPressed("1") || P64.justPressed("3"):
				match scrollAnimations[scrollIndex]:
					"Run":
						C.activate("Menu","Run")
						C.get_node("Run").runGame()
					"Load":
						#$"../" highlight options?
						C.activate("Menu","Load")
					"Code":
						C.activate("Menu","Code")
					"Texture":
						C.activate("Menu","Texture")
					"Model":
						C.activate("Menu","Model")
					"Audio":
						C.activate("Menu","Audio")
					_:
						P64.print(20,150,"No File Selected",self,5)
				soundSelect.play()
				
		if timer.is_stopped() && !introDone:
			introDone = true
	# selection
	pass

func setMenuVisual(newIndex) -> void: 
	scrollIndex = newIndex
	scroller.scroll_vertical = scrollDistances[scrollIndex]
	optionPlayer.play(scrollAnimations[scrollIndex])

func _pressMenuButton(buttonName) -> void:
	Input.action_press(buttonName)
