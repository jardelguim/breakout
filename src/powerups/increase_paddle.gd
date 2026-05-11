extends PowerUp

class_name IncreasePaddlePowerUp

var paddle: CharacterBody2D

func _ready() -> void:
	icon = load("res://assets/sprites/powerups/size_up_icon.png")

func _init(paddle_obj: CharacterBody2D):
	paddle = paddle_obj

func activate():
	paddle.wider_paddle()
