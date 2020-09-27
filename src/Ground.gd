extends StaticBody2D


signal destroyed()


onready var playerCamera := get_node("/root/Main/Player/Camera2D")


# Called when the node enters the scene tree for the first time.
func _ready():
	print('playerCamera:', playerCamera.global_position)
	pass


# free ground if no longer visible on player camera
func _process(delta):
	var x_pos = global_position.x
	# TODO: 320 is half screen width; not sure why it's needed here
	if x_pos + Constants.GROUND_WIDTH + 320 < playerCamera.global_position.x:
		print('playerCamera:', playerCamera.global_position)
		queue_free()
		emit_signal("destroyed")
