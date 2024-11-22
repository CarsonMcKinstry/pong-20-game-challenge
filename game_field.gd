class_name GameField
extends Node2D

const INITIAL_COUNTDOWN: int = 3

const WIN_TEXT: String = "%s wins!"
const PLAY_AGAIN_TEXT: String = "press space to play again"
const GO_TEXT: String = "Go!"

@export var to_win: int = 10

@export var ball: Ball
@export var left_paddle: Paddle
@export var right_paddle: Paddle
@export var divider: VFlowContainer
@export var start_label: Label
@export var win_label: Label
@export var countdown_label: Label
@export var left_score_label: Label
@export var right_score_label: Label

@export var timer: Timer

enum LastPoint {
	LEFT,
	RIGHT
}

enum GameState {
	WAITING_TO_START,
	COUNTDOWN,
	PLAYING,
	GAME_OVER
}

var _rng := RandomNumberGenerator.new()

var _last_point: LastPoint

var _countdown: int:
	set(next_count):
		_countdown = next_count
		_handle_countdown_tick()

var _current_state: GameState:
	set(next_state):
		_current_state = next_state
		_handle_state_change()

var _left_points: int = 0:
	set(next_score):
		_left_points = next_score
		_update_scoreboard()
		_check_win_condition()
	
var _right_points: int = 0:
	set(next_score):
		_right_points = next_score
		_update_scoreboard()
		_check_win_condition()

func _ready():
	_validate_dependencies()
	_init_game()

func _init_game():
	_last_point = LastPoint.LEFT if _rng.randi_range(0, 10) < 5 else LastPoint.RIGHT
	_countdown = INITIAL_COUNTDOWN
	_current_state = GameState.WAITING_TO_START

# ========= Input Handlers =========

func _unhandled_key_input(event):
	if _current_state == GameState.WAITING_TO_START || _current_state == GameState.GAME_OVER:
		if (event is InputEventKey):
			if (event.is_pressed() && event.keycode == KEY_SPACE):
				_left_points = 0
				_right_points = 0
				_current_state = GameState.COUNTDOWN

# ========= Event Handlers =========

func _on_timer_timeout():
	_countdown -= 1

func _on_ball_right_wall_hit():
	_left_points += 1

func _on_ball_left_wall_hit():
	_right_points += 1

# ========= UI Updates =========

func _update_scoreboard():
	left_score_label.text = str(_left_points)
	right_score_label.text = str(_right_points)

func _show_start_screen():
	ball.hide()
	divider.hide()
	countdown_label.hide()
	win_label.hide()

	start_label.show()

func _show_countdown_screen():
	ball.hide()
	divider.hide()

	countdown_label.show()

	win_label.hide()
	start_label.hide()

func _show_gameover_screen():
	ball.hide()
	divider.hide()

	countdown_label.hide()

	win_label.show()
	win_label.text = WIN_TEXT % _get_winner_text()

	start_label.show()
	start_label.text = PLAY_AGAIN_TEXT

func _show_gameplay_screen():
	ball.show()
	divider.show()

	countdown_label.hide()

	win_label.hide()
	start_label.hide()

func _handle_countdown_tick():
	if _countdown == 0:
		countdown_label.text = GO_TEXT
		timer.stop()
		_current_state = GameState.PLAYING
	else:
		countdown_label.text = str(_countdown)

# ========= Game State Change Handlers =========

func _handle_state_change():
	match _current_state:
		GameState.WAITING_TO_START:
			_handle_waiting_to_start()
		GameState.COUNTDOWN:
			_handle_countdown()
		GameState.PLAYING:
			_handle_playing()
		GameState.GAME_OVER:
			_handle_game_over()

func _handle_waiting_to_start():
	_show_start_screen()

func _handle_countdown():
	_show_countdown_screen()
	_countdown = INITIAL_COUNTDOWN
	_reset_ball()
	timer.start()
	ball.playing = false
	left_paddle.playing = true
	right_paddle.playing = true

func _handle_playing():
	_show_gameplay_screen()
	timer.stop()
	ball.playing = true
	ball.start(_last_point)

func _handle_game_over():
	_reset_ball()
	_reset_paddles()
	_show_gameover_screen()
	timer.stop()
	ball.playing = false
	left_paddle.playing = false
	right_paddle.playing = false

# ========= Utils =========

func _check_win_condition():
	if _left_points == to_win || _right_points == to_win:
		_current_state = GameState.GAME_OVER
	else:
		_current_state = GameState.COUNTDOWN

func _get_winner_text():
	match _last_point:
		LastPoint.LEFT:
			return "Left"
		LastPoint.RIGHT:
			return "Right"

func _reset_ball():
	ball.reset_position()

func _reset_paddles():
	left_paddle.reset_position()
	right_paddle.reset_position()

# ========= Validation Below =========

func _validate_dependencies():
	assert(ball, "ball missing")
	assert(left_paddle, "left_paddle missing")
	assert(right_paddle, "right_paddle missing")
	assert(divider, "divider missing")
	assert(start_label, "start_label missing")
	assert(win_label, "win_label missing")
	assert(countdown_label, "countdown_label missing")
	assert(left_score_label, "left_score_label missing")
	assert(right_score_label, "right_score_label missing")
	assert(timer, "timer missing")
