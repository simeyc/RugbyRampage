extends KinematicBody2D

enum State {IDLE, RUN, SIDESTEP, TACKLED}

export var dodge = false

# constants
var SPEED = 50
# TODO: constants.gd?
var GRAVITY = 2000
var MAX_FALL_SPEED = GRAVITY

# variables
var velocity = Vector2()
var state = State.IDLE
var dodgeable_enemy = null


# Called when the node enters the scene tree for the first time.
func _ready():
	_enter_state(state)


func _enter_state(new_state):
	if state == State.TACKLED:
		return # don't leave tackled state
	state = new_state
	match state:
		State.RUN:
			velocity.x = SPEED
			$AnimatedSprite.scale = Vector2(1, 1)
			dodge = false
		State.SIDESTEP:
			$SidestepTimer.start()
			$AnimatedSprite.scale = Vector2(1.2, 1.2)
			dodge = dodgeable_enemy != null
		State.TACKLED:
			velocity.x = 0
			$AnimatedSprite.rotation = -PI/2
			$AnimatedSprite.position.y += 10
	$DebugLabel.text = State.keys()[state] + ' SPEED: ' + str(velocity.x)


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


func _body_is_enemy(body):
	return body.collision_layer == (1 << Constants.CollisionBit.ENEMY)

func _on_SidestepTimer_timeout():
	_enter_state(State.RUN)


func _on_SidestepSweetArea_body_entered(body):
	if _body_is_enemy(body):
		dodgeable_enemy = body


func _on_SidestepSweetArea_body_exited(body):
	if body == dodgeable_enemy:
		dodgeable_enemy = null


func _on_ContactArea_body_entered(body):
	if !dodge && _body_is_enemy(body):
		_enter_state(State.TACKLED)
		
