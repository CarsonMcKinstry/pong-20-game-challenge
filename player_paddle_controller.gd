class_name PlayerPaddleController 
extends PaddleController

@export var UP_ACTION: String
@export var DOWN_ACTION: String


func _physics_process(delta):
	if Input.is_action_pressed(UP_ACTION):
		move_up()
	elif Input.is_action_pressed(DOWN_ACTION):
		move_down()
	else:
		reset_velocity()
