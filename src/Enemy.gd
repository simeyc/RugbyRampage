extends KinematicBody2D

enum State { RUN, TACKLE, TACKLE_HIT, TACKLE_MISS }

# variables
var speed = 100
var velocity = Vector2(-speed, Constants.MAX_FALL_SPEED)
var state = State.RUN

func _ready():
	_enter_state(state)
	var sprite_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = sprite_types[randi() % sprite_types.size()]
	move_and_slide(velocity)

func _physics_process(delta):
	move_and_slide(velocity)

func _enter_state(new_state):
	state = new_state
	if state == State.TACKLE:
		$AnimatedSprite.rotation = -PI/4
	elif state == State.TACKLE_HIT:
		emit_signal('tackle')
	$DebugLabel.text = State.keys()[state]


func _on_TackleRange_body_entered(body):
	if body.name == "Player":
		_enter_state(State.TACKLE)


func _on_ContactArea_body_entered(body):
	if body.name == "Player":
		_enter_state(State.TACKLE_MISS if body.dodge else State.TACKLE_HIT)
