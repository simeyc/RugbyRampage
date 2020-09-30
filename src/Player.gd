extends KinematicBody2D
class_name PlayerController

signal tackled()

enum State {IDLE, RUN, SIDESTEP, TACKLED}

# constants
var SPEED = 200
var SIDESTEP_TIME = 0.2

# private members
var _state = State.IDLE
var _velocity := Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	_enter_state(_state)
	$SidestepTimer.wait_time = SIDESTEP_TIME


# called by enemy to attempt tackle, return true if tackle successful
func tackle(force):
	var tackled = _state != State.SIDESTEP
	if tackled:
		_velocity.x = -force
		_enter_state(State.TACKLED)
		emit_signal("tackled")
	return tackled
	

func _enter_state(new_state):
	if _state == State.TACKLED:
		return # don't leave tackled state
	_state = new_state
	match _state:
		State.RUN:
			_velocity.x = SPEED
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
	if _state == State.IDLE and event.is_action_pressed("ui_right"):
		_enter_state(State.RUN)
	elif _state == State.RUN and event.is_action_pressed("ui_accept"):
		_enter_state(State.SIDESTEP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# apply gravity
	_velocity.y += Constants.GRAVITY * delta
	_velocity.y = min(_velocity.y, Constants.MAX_FALL_SPEED)
	
	if _state == State.TACKLED:
		# moving left
		_velocity.x += Constants.DECELERATION
		if _velocity.x >= 0:
			_velocity.x = 0
			# TODO: start GAME_OVER timer
	
	# update movement
	_velocity.y = move_and_slide(_velocity, Vector2.UP).y


func _on_SidestepTimer_timeout():
	_enter_state(State.RUN)
