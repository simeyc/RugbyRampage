extends KinematicBody2D

const PlayerController = preload("res://src/Player.gd")

enum State { RUN, TACKLE, TACKLE_HIT, TACKLE_MISS }

# constants
const TACKLE_FORCE = 200

# variables
var speed := 100
var _velocity := Vector2(-speed, Constants.MAX_FALL_SPEED)
var _state = State.RUN


func _ready():	
	_enter_state(_state)
	var sprite_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = sprite_types[randi() % sprite_types.size()]

func _physics_process(delta):
	if _state in [State.TACKLE_MISS, State.TACKLE_HIT]:
		_velocity.x += Constants.DECELERATION
		_velocity.x = min(_velocity.x, 0)
	_velocity.y = move_and_slide(_velocity).y

func _enter_state(new_state):
	_state = new_state
	match _state:
		State.TACKLE:
			$AnimatedSprite.rotation = -PI/4
			_velocity.x = -TACKLE_FORCE
	#$DebugLabel.text = State.keys()[_state]


func _on_TackleRange_body_entered(body):
	var player := body as PlayerController
	if player:
		_enter_state(State.TACKLE)


func _on_ContactArea_body_entered(body):
	var player := body as PlayerController
	if player:
		if player.state != Constants.PlayerState.SIDESTEP:
			player.on_tackled(TACKLE_FORCE)
			_enter_state(State.TACKLE_HIT)
		else:
			_enter_state(State.TACKLE_MISS)
