extends PowerUp

class_name IncreasePaddlePowerUp

var paddle: CharacterBody2D

func _init(paddle_obj: CharacterBody2D):
	icon = load("res://assets/sprites/powerups/size_up_icon.png")
	paddle = paddle_obj

func activate(kwargs: Dictionary = {}):
	paddle.wider_paddle()
