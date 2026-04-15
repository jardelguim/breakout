extends Node2D

@onready var ball: CharacterBody2D = $Ball
@onready var grid: Node2D = $Grid
@onready var frame: TextureRect = $Frame
@onready var screen_size : Vector2 = frame.size
@onready var screen_center : Vector2 = screen_size / 2

func _process(_delta: float) -> void:
	pass

func _ready() -> void:
	print(screen_size)
	grid.start_grid()
	ball.position = screen_center

	
