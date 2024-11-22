class_name Paddle
extends CharacterBody2D

@export var SPEED: int = 500

var initial_position: Vector2i

var playing: bool = false

func _ready():
	initial_position = position

func _physics_process(_delta):
	if playing:
		move_and_slide()

func reset_position():
	position = initial_position
