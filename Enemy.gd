extends KinematicBody2D

var speed = 100
var gravity = 800

var velocity = Vector2(-speed, gravity)

func _ready():
	var sprite_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = sprite_types[randi() % sprite_types.size()]

func _physics_process(delta):
	#if is_on_wall():
	#	hide()
	#	queue_free()
	move_and_slide(velocity, Vector2.UP)
