extends KinematicBody2D
class_name PlayerController

signal game_over()

const State := Constants.PlayerState

# constants
var SPEED = 200

# public members
var state = State.IDLE

# private members
var _velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	_enter_state(state)


# called by enemy when player is tackled
func on_tackled(force):
	_velocity.x = -force
	_enter_state(State.TACKLED)
	

func _enter_state(new_state):
	if state == State.TACKLED:
		return # don't leave tackled state
	state = new_state
	match state:
		State.RUN:
			_velocity.x = SPEED
			$AnimatedSprite.scale = Vector2(1, 1)
		State.SIDESTEP:
			$SidestepTimer.start()
			# TODO: modifies velocity??
			$AnimatedSprite.scale = Vector2(1.2, 1.2)
		State.TACKLED:
			$AnimatedSprite.rotation = -PI/2
			$AnimatedSprite.position.y += 10
	#$DebugLabel.text = State.keys()[state]


func _input(event):	
	if state == State.IDLE and event.is_action_pressed("ui_right"):
		_enter_state(State.RUN)
	elif state == State.RUN and event.is_action_pressed("ui_accept"):
		_enter_state(State.SIDESTEP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# apply gravity
	_velocity.y += Constants.GRAVITY * delta
	_velocity.y = min(_velocity.y, Constants.MAX_FALL_SPEED)
	
	if state == State.TACKLED:
		# moving left
		_velocity.x += Constants.DECELERATION
		if _velocity.x >= 0:
			_velocity.x = 0
			# TODO: start GAME_OVER timer
	
	# update movement
	_velocity.y = move_and_slide(_velocity, Vector2.UP).y


func _on_SidestepTimer_timeout():
	_enter_state(State.RUN)
