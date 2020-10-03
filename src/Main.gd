extends Node2D

var _game_over := false

onready var GameOverLabel = $GameOverHUD/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	GameOverLabel.visible = false

func _input(event):
	if _game_over and event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
		_game_over = false


func _on_Player_tackled():
	_game_over = true
	GameOverLabel.visible = true
