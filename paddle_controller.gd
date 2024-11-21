class_name PaddleController extends Node

@export var body: CharacterBody2D;

func move_down():
	body.velocity = Vector2(0, 500);
	
func move_up():
	body.velocity = Vector2(0, -500);

func reset_velocity():
	body.velocity = Vector2.ZERO;
