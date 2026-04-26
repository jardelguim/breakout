extends Node2D

const max_columns = 20
const max_screen_size = 320
@export var columns : int = 8
@export var rows : int = 3
@export var brick : PackedScene
var brick_height = 15
var brick_width = 15
var left_screen_offset = 0
var x_offset = 18 + ((brick_width * (max_columns - columns)/2))
var y_offset = 15


@onready var brick_container: Marker2D = $BrickContainer
@onready var paddle: CharacterBody2D = %Paddle


func _ready() -> void:
	pass
	#start_grid()

func start_grid() -> void:
	'''Função para gerar um novo grid de bricks'''
	var bricks : Array

	for line in range(rows):
		var line_array = []
		var line_brick_type = GameManager.brick_types.pick_random()
		var color = GameManager.brick_colors.pick_random()
		
		for col in range(columns):
			var new_brick = brick.instantiate()
			# Set brick position
			var pos = Vector2(
				left_screen_offset + (col * brick_width + x_offset), y_offset + line * brick_height
			)
			# Set brick color and score given based on type
			new_brick.brick_type = line_brick_type
			new_brick.set_brick_type()	
			new_brick.position = pos
			#GameManager.brick_colors.erase(color)
			#GameManager.brick_types.erase(line_brick_type)
			line_array.append(new_brick)
			brick_container.add_child(new_brick)
		bricks.append(line_array)
	
	var last_brick = bricks[-1][-1]
