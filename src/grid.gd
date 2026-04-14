extends Node2D

@export var columns : int = 20
@export var rows : int = 3
@export var brick : PackedScene
var brick_height = 10
var brick_width = 10
var x_offset = 17
var y_offset = 15
var padding = 5

@onready var brick_container: Marker2D = $BrickContainer

func _ready() -> void:
	pass
	#start_grid()

func start_grid() -> void:
	'''Função para gerar um novo grid de bricks'''
	for x in range(columns):
		for y in range(rows):
			# Add random open spaces
			var randomNumber = randi_range(0 , 2)
			if randomNumber > 0:
				var new_brick = brick.instantiate()
				var x_pos = x_offset + x * (brick_width + padding)
				var y_pos = y_offset + y * (brick_height + padding)
				new_brick.position = Vector2(x_pos , y_pos)
				brick_container.add_child(new_brick)
