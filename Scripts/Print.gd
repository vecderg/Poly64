extends CanvasLayer

var time: float
var text: String

func create(printTime:int, printText:String):
	time = printTime
	text = printText
	
func _ready():
	get_child(0).text = text

func _process(delta):
	time -= delta
	if time <= 0:
		self.queue_free()
