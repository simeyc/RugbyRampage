extends Label

var _score := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Player_beat_enemy():
	_score += 1
	text = "Score: %d" % _score
