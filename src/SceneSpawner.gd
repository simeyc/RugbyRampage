extends Node
class_name SceneSpawner


var _scene : PackedScene = null
var _position = Vector2(0, 0)


func _set_scene(scene: PackedScene):
	_scene = scene


# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_scene()
	_spawn_scene()
	
	
func _spawn_scene():
	var scene = _scene.instance()
	scene.position = _position
	scene.connect("destroyed", self, "_spawn_scene")
	add_child(scene)
	_position.x += Constants.GROUND_WIDTH
