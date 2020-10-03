extends KinematicBody2D
class_name PlayerController

signal tackled()
signal beat_enemy()

enum State {IDLE, RUN, SIDESTEP, TACKLED}

# constants
var SPEED = 200
var SIDESTEP_TIME = 0.2

# private members
var _state = State.IDLE
var _speed := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_enter_state(_state)
	$SidestepTimer.wait_time = SIDESTEP_TIME


# called by enemy to attempt tackle, return true if tackle successful
func tackle(force):
	var tackled = _state != State.SIDESTEP
	if tackled:
		_speed = -force
		_enter_state(State.TACKLED)
		emit_signal("tackled")
	else:
		emit_signal("beat_enemy")
	return tackled
	

func _enter_state(new_state):
	if _state == State.TACKLED:
		return # don't leave tackled state
	_state = new_state
	match _state:
		State.RUN:
			_speed = SPEED
			$AnimatedSprite.scale = Vector2(1, 1)
			$AnimatedSprite.position.y = 0
		State.SIDESTEP:
			$SidestepTimer.start()
			$AnimatedSprite.scale = Vector2(1.1, 1.1)
			$AnimatedSprite.position.y = 5
		State.TACKLED:
			$AnimatedSprite.rotation = -PI/2
			$AnimatedSprite.position.y += 10
	#$DebugLabel.text = State.keys()[state]


func _input(event):	
	if _state == State.RUN and event.is_action_pressed("ui_accept"):
		_enter_state(State.SIDESTEP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	if _state == State.TACKLED:
		# moving left
		_speed += Constants.DECELERATION
		if _speed >= 0:
			_speed = 0
	
	# fall to ground at high speed, then stay snapped to floor
	move_and_slide_with_snap(Vector2(_speed, 10000), Vector2.DOWN, Vector2.UP)


func _on_SidestepTimer_timeout():
	_enter_state(State.RUN)


func _on_Countdown_done():
	_enter_state(State.RUN)
