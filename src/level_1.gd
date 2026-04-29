extends Node2D

@onready var ball: CharacterBody2D = $Ball
@onready var grid: Node2D = $Grid
@onready var screen_size : Vector2 = Vector2( 320, 320)
@onready var screen_center : Vector2 = screen_size / 2

func _ready() -> void:
	grid.start_grid()
	ball.position = screen_center
