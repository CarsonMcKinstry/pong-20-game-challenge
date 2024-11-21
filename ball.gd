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
		GameField.LastPoint.Left:
			velocity = Vector2(-500, 0)
		GameField.LastPoint.Right:
			velocity = Vector2(500, 0)

func collide_left():
	velocity = Vector2(SPEED, 0) + left_paddle.velocity

func collide_right():
	velocity = Vector2(-SPEED, 0) + right_paddle.velocity

func collide_top():
	velocity = Vector2(velocity.x, SPEED)

func collide_bottom():
	velocity = Vector2(velocity.x, -SPEED)

func collide_left_wall():
	left_wall_hit.emit()

func collide_right_wall():
	right_wall_hit.emit()

func _physics_process(delta):
	
	var collided = move_and_slide()
	
	if collided:
		var collider = get_last_slide_collision().get_collider()
		
		match collider:
			left_paddle:
				collide_left()
			right_paddle:
				collide_right()
			top_wall:
				collide_top()
			bottom_wall:
				collide_bottom()
			left_wall:
				collide_right_wall()
			right_wall:
				collide_left_wall()
