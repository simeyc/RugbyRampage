extends KinematicBody2D
class_name PlayerController

signal tackled()
signal beat_enemy()

enum State {IDLE, RUN, SIDESTEP_RIGHT, SIDESTEP_LEFT, HANDOFF, TACKLED}

# constants
var SPEED = 200
var DODGE_TIME = 0.2

# private members
var _state = State.IDLE
var _speed := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_enter_state(_state)
	$DodgeTimer.wait_time = DODGE_TIME


# called by enemy to attempt tackle, return true if tackle successful
func tackle(force):
	var tackled = [State.IDLE, State.RUN].has(_state)
	var result = Constants.TackleResult.MISS
	if tackled:
		result = Constants.TackleResult.HIT
		_speed = force
		_enter_state(State.TACKLED)
		emit_signal("tackled")
	elif _state == State.HANDOFF:
		result = Constants.TackleResult.BREAK
		force = -force
	else: 
		emit_signal("beat_enemy")
	return { "result": result, "force": force }
	

func _enter_state(new_state):
	if _state == State.TACKLED:
		return # don't leave tackled state
	_state = new_state
	match _state:
		State.RUN:
			_speed = SPEED
			$AnimatedSprite.animation = 'run'
			$AnimatedSprite.scale = Vector2(1, 1)
			$AnimatedSprite.position.y = 0
			z_index = 0
		State.SIDESTEP_RIGHT:
			$DodgeTimer.start()
			$AnimatedSprite.scale = Vector2(1.1, 1.1)
			$AnimatedSprite.position.y = 5
			z_index = 1
		State.SIDESTEP_LEFT:
			$DodgeTimer.start()
			$AnimatedSprite.scale = Vector2(0.9, 0.9)
			$AnimatedSprite.position.y = -5
		State.TACKLED:
			$AnimatedSprite.rotation = -PI/2
			$AnimatedSprite.position.y += 10
		State.HANDOFF:
			$AnimatedSprite.animation = 'handoff'
			$DodgeTimer.start()
	#$DebugLabel.text = State.keys()[state]


func _input(event):	
	if _state == State.RUN:
		if event.is_action_pressed("ui_down"):
			_enter_state(State.SIDESTEP_RIGHT)
		elif event.is_action_pressed("ui_up"):
			_enter_state(State.SIDESTEP_LEFT)
		elif event.is_action_pressed("ui_right"):
			_enter_state(State.HANDOFF)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	if _state == State.TACKLED:
		# moving left
		_speed += Constants.DECELERATION
		if _speed >= 0:
			_speed = 0
	
	# fall to ground at high speed, then stay snapped to floor
	move_and_slide_with_snap(Vector2(_speed, 10000), Vector2.DOWN, Vector2.UP)


func _on_DodgeTimer_timeout():
	_enter_state(State.RUN)


func _on_Countdown_done():
	_enter_state(State.RUN)

