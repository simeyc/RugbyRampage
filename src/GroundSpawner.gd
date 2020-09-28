extends Node


var Ground := preload("res://scenes/Ground.tscn")


var _position := Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_ground()
	_spawn_ground()
	
	
func _spawn_ground():
	var ground = Ground.instance()
	ground.position = _position
	ground.connect("destroyed", self, "_spawn_ground")
	add_child(ground)
	_position.x += Constants.GROUND_WIDTH
