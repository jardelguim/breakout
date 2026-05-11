extends PowerUp

class_name SpeederPowerUp

var paddle: CharacterBody2D

func _ready() -> void:
	icon = load("res://assets/sprites/powerups/speed_icon.png")

func _init(paddle_obj: CharacterBody2D):
	paddle = paddle_obj

func activate():
	paddle.speed_up()
