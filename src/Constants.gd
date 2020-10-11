extends Node

const DECELERATION = 10
const GROUND_WIDTH = 700
const BOUND_LOWER = 330
const BOUND_UPPER = 130

enum CollisionLayer {ENVIRONMENT=1, PLAYER=2, ENEMY=4}

enum TackleResult {HIT, MISS, BREAK}
