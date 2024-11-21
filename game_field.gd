class_name GameField
extends Node2D

@export	var ball: Ball
@export var left_paddle: Paddle
@export var right_paddle: Paddle

enum LastPoint {
	Left,
	Right
}

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var last_point: LastPoint

func _ready():
	assert(left_paddle)
	assert(right_paddle)
	assert(ball)
	
	var starting_direction: int = rng.randi_range(1, 10)
	
	last_point = LastPoint.Left if starting_direction < 5 else LastPoint.Right
	
	ball.start(last_point)

func pause_game():
	get_tree().paused = true
	reset_positions()

func _on_ball_left_wall_hit():
	pause_game()
	
func _on_ball_right_wall_hit():
	pause_game()

func reset_positions():
	ball.reset_position()
	left_paddle.reset_position()
	right_paddle.reset_position()
