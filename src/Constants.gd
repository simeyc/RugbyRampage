extends Node

const GRAVITY = 2000
const MAX_FALL_SPEED = 2000
const DECELERATION = 10
const GROUND_WIDTH = 700

enum PlayerState {IDLE, RUN, SIDESTEP, TACKLED}

enum CollisionLayer {ENVIRONMENT=1, PLAYER=2, ENEMY=4}
