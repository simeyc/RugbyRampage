extends KinematicBody2D

const PlayerController = preload("res://src/Player.gd")

enum State { RUN, TACKLE, TACKLE_HIT, TACKLE_MISS, IDLE }

# constants
const TACKLE_FORCE = 200
const MIN_SPEED = 50
const MAX_SPEED = 200

# variables
var _speed : int
var _state = State.RUN

onready var camera = get_node("/root/Main/Player/Camera2D")


func _ready():
	_speed = -rand_range(MIN_SPEED, MAX_SPEED)
	var sprite_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = sprite_types[randi() % sprite_types.size()]


func _process(delta):
	# free when off screen a bit
	if global_position.x < camera.get_camera_screen_center().x - Constants.GROUND_WIDTH / 2:
		queue_free()


func _physics_process(delta):
	if _state in [State.TACKLE_MISS, State.TACKLE_HIT]:
		_speed += Constants.DECELERATION
		_speed = min(_speed, 0)
	# TODO: why is move_and_slide_with_snap not working??
	#move_and_slide_with_snap(Vector2(_speed, 0), Vector2.DOWN * 320, Vector2.UP)
	move_and_slide(Vector2(_speed, Constants.GRAVITY), Vector2.UP)


func _enter_state(new_state):
	_state = new_state
	if _state == State.TACKLE:
		$AnimatedSprite.rotation = -PI/4
		_speed = -TACKLE_FORCE
	elif _state == State.IDLE:
		_speed = 0
	#$DebugLabel.text = State.keys()[_state]


func _on_TackleRange_body_entered(body):
	var player := body as PlayerController
	if player:
		_enter_state(State.TACKLE)


func _on_ContactArea_body_entered(body):
	var player := body as PlayerController
	if player:
		if player.tackle(TACKLE_FORCE):
			_enter_state(State.TACKLE_HIT)
		else:
			_enter_state(State.TACKLE_MISS)

func _on_Player_tackled():
	if _state == State.TACKLE:
		_enter_state(State.TACKLE_MISS)
	elif _state == State.RUN:
		_enter_state(State.IDLE)
