extends Node2D

signal game_start()

var _started := false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _input(event):
	if !_started and event.is_action_pressed("ui_accept"):
		emit_signal("game_start")
		_started = true
