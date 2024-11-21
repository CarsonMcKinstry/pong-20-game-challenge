class_name GameField
extends Node2D

@export	var ball: Ball
@export var left_paddle: Paddle
@export var right_paddle: Paddle
@export var timer: Timer
@export var divider: VFlowContainer
@export var start_label: Label
@export var countdown_label: Label

@export var left_score_label: Label
@export var right_score_label: Label

enum LastPoint {
	Left,
	Right
}

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var last_point: LastPoint

var countdown: int = 3:
	set(next_value):
		countdown = next_value
		if countdown == 0:
			countdown_label.text = "Go!"
		else:
			countdown_label.text = str(next_value)

var playing: bool = false:
	set(next_value):
		playing = next_value
		ball.playing = next_value
		left_paddle.playing = next_value
		right_paddle.playing = next_value

var left_score: int = 0:
	set(next_value):
		left_score = next_value
		left_score_label.text = str(left_score)
		check_win_condition()
		
var right_score: int = 0:
	set(next_value):
		right_score = next_value
		right_score_label.text = str(right_score)
		check_win_condition()

func _ready():	
	ball.hide()
	
	var starting_direction: int = rng.randi_range(1, 10)
	
	last_point = LastPoint.Left if starting_direction < 5 else LastPoint.Right
	
	countdown_label.text = str(countdown)
	

func _unhandled_key_input(event: InputEvent):
	if !playing && (event as InputEventKey).is_pressed() && (event as InputEventKey).keycode == KEY_SPACE:
		start_label.hide()
		countdown_label.show()
		timer.start()

func start():
	playing = true
	countdown_label.hide()
	divider.show()
	ball.show()
	ball.start(last_point)

func pause_game():
	playing = false
	reset_positions()
	divider.hide()
	ball.hide()
	countdown_label.show()
	countdown = 3
	timer.start()

func _on_ball_left_wall_hit():
	last_point = LastPoint.Left
	right_score += 1
	pause_game()
	
func _on_ball_right_wall_hit():
	last_point = LastPoint.Right
	left_score += 1
	pause_game()

func reset_positions():
	ball.reset_position()

func _on_timer_timeout():
	if countdown == 0:
		timer.stop()
		start()
	else:
		countdown -= 1

func check_win_condition():
	if left_score == 10:
		pass
	elif right_score == 10:
		pass
	

func export_assertions():
	assert(countdown_label)
	assert(start_label)
	assert(divider)
	assert(timer)
	assert(left_paddle)
	assert(right_paddle)
	assert(ball)
	assert(left_score_label)
	assert(right_score_label)
