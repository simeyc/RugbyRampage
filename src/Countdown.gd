extends Label

signal done()

var _countdown := 3

func _on_Timer_timeout():
	if _countdown > 0:
		text = str(_countdown)
	else:
		text = 'Go!'
		$Timer.stop()
		emit_signal('done')
	_countdown -= 1
