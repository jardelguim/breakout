extends Node2D

@export var columns : int = 9
@export var rows : int = 3
@export var brick : PackedScene
var brick_height = 8
var brick_width = 28
var x_offset = 20
var y_offset = 20
var padding = 5

func start_grid() -> void:
	'''Função para gerar um novo grid de bricks'''
	for x in range(columns):
		for y in range(rows):
			var new_brick = brick.instantiate()
			var x_pos = x_offset + x * (brick_width + padding)
			var y_pos = y_offset + y * (brick_height + padding)
			new_brick.position = Vector2(x_pos , y_pos)
			add_child(new_brick)
	
	
func _add_brick(brick_height , brick_width) -> void:
	pass
