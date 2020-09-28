extends StaticBody2D


signal destroyed()


onready var playerCamera := get_node("/root/Main/Player/Camera2D")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# free ground if no longer visible on player camera
func _process(delta):
	var x_pos = global_position.x
	if x_pos + Constants.GROUND_WIDTH < playerCamera.get_camera_screen_center().x - 320:
		queue_free()
		emit_signal("destroyed")
