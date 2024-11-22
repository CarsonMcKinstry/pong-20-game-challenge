class_name Paddle
extends CharacterBody2D

@export var SPEED: int = 500

enum PaddleState {
	MOVING,
	STATIONARY
}

var _initial_position: Vector2i

var _current_state = PaddleState.STATIONARY

func _ready():
	_initial_position = position

func _physics_process(_delta):
	if _current_state == PaddleState.MOVING:
		move_and_slide()

func start():
	_current_state = PaddleState.MOVING

func stop():
	_current_state = PaddleState.STATIONARY

func reset_position():
	position = _initial_position
