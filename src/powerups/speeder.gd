extends PowerUp

class_name SpeederPowerUp

var paddle: CharacterBody2D

func _init(paddle_obj: CharacterBody2D):
	icon = load("res://assets/sprites/powerups/speed_icon.png")
	paddle = paddle_obj

func activate(kwargs: Dictionary = {}):
	paddle.speed_up()
