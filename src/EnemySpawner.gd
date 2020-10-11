extends Node


const Enemy := preload("res://scenes/Enemy.tscn")


var _position := Vector2()


onready var timer := $Timer
onready var player := get_parent().get_node("Player")
onready var camera := player.get_node("Camera2D")


# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("tackled", self, "_stop")
	_set_timeout()


func _process(delta):
	pass


func _set_timeout():
	# set random timeout within range
	timer.wait_time = rand_range(0.5, 1.5)


func _on_Timer_timeout():
	var enemy = Enemy.instance()
	add_child(enemy)
	# set position just off screen
	_position.x = camera.get_camera_screen_center().x + Constants.GROUND_WIDTH / 2
	_position.y = rand_range(Constants.BOUND_UPPER, Constants.BOUND_LOWER)
	enemy.position = _position
	player.connect("tackled", enemy, "_on_Player_tackled")
	_set_timeout()


func _stop():
	timer.stop()


func _on_Countdown_done():
	timer.start()
