extends KinematicBody2D

enum State {IDLE, RUN, SIDESTEP, TACKLED}

export var dodge = false

# constants
var SPEED = 200
# TODO: constants.gd?
var GRAVITY = 2000
var MAX_FALL_SPEED = GRAVITY

# variables
var velocity = Vector2()
var state = State.IDLE


# Called when the node enters the scene tree for the first time.
func _ready():
	_enter_state(state)


func _enter_state(new_state):
	if new_state == State.RUN:
		velocity.x = SPEED
		$AnimatedSprite.scale = Vector2(1, 1)
		dodge = false
	elif new_state == State.SIDESTEP:
		$SidestepTimer.start()
		$AnimatedSprite.scale = Vector2(1.2, 1.2)
		dodge = true
	state = new_state
	$DebugLabel.text = State.keys()[state]


func _input(event):	
	if state == State.IDLE and event.is_action_pressed("ui_right"):
		_enter_state(State.RUN)
	elif state == State.RUN and event.is_action_pressed("ui_accept"):
		_enter_state(State.SIDESTEP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# apply gravity
	velocity.y = min(velocity.y + Constants.GRAVITY * delta, Constants.MAX_FALL_SPEED)
	
	# update movement
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_SidestepTimer_timeout():
	_enter_state(State.RUN)


# TODO: if collided with enemy while state != SIDESTEP, tackled!
