extends KinematicBody2D

enum State {IDLE, SIDESTEPPING, RUNNING, AIRBORNE, TACKLED}

var SPEED = 300 # px/sec
var JUMP_FORCE = 200
var GRAVITY = 800
var MAX_FALL_SPEED = 800

#const UP = Vector2(0, -1)

var velocity = Vector2()
var state = State.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# TODO: set velocity.y to 0 when finished jump
func _input(event):
	 #jump
	if is_on_floor() and event.is_action_pressed("ui_up"):
		velocity.y = -JUMP_FORCE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	# move left and right
	velocity.x = 0
	if Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
	
	# face current direction
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true
	
	# apply gravity
	velocity.y = min(velocity.y + GRAVITY * delta, MAX_FALL_SPEED)
	
	# update movement
	velocity = move_and_slide(velocity, Vector2.UP)
