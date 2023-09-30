extends CanvasLayer

var time: float

func create(printTime:int):
	time = printTime
	
func _ready():
	pass

func _process(delta):
	time -= delta
	if time <= 0:
		self.queue_free()
