class_name Ball
extends CharacterBody2D

@export var SPEED: int = 500
@export var left_paddle: Paddle
@export var right_paddle: Paddle

@export var left_wall: StaticBody2D
@export var right_wall: StaticBody2D
@export var top_wall: StaticBody2D
@export var bottom_wall: StaticBody2D

signal left_wall_hit
signal right_wall_hit

var initial_position: Vector2i

var playing: bool = false

func _ready():
	initial_position = position
	assert(left_paddle)
	assert(right_paddle)
	assert(left_wall)
	assert(right_wall)
	assert(top_wall)
	assert(bottom_wall)

func reset_position():
	position = initial_position

func start(last_point: GameField.LastPoint):
	match last_point:
		GameField.LastPoint.Right:
			velocity = Vector2(-500, 0)
		GameField.LastPoint.Left:
			velocity = Vector2(500, 0)

func collide_left_wall():
	left_wall_hit.emit()

func collide_right_wall():
	right_wall_hit.emit()

func _physics_process(delta):
	if playing:
		var collision_info = move_and_collide(velocity * delta)

		if collision_info:
			var collider = collision_info.get_collider()
			
			match collider:
				left_wall:
					collide_left_wall()
					return
				right_wall:
					collide_right_wall()
					return
				left_paddle, right_paddle:
					var paddle_velocity = (collider as Paddle).velocity
					if paddle_velocity.y != 0:
						velocity.y = (collider as Paddle).velocity.y
			velocity = velocity.bounce(collision_info.get_normal())
					
