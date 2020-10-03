extends Label

signal done()

var _countdown := 3

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(_countdown)


func _on_Timer_timeout():
	_countdown -= 1
	if _countdown > 0:
		text = str(_countdown)
	else:
		text = 'Go!'
		$Timer.stop()
		emit_signal('done')
