extends Node2D

const max_columns = 21
@export var columns : int = 12
@export var rows : int = 3
@export var brick : PackedScene
var brick_height = 15
var brick_width = 15
var x_offset = 0
var y_offset = 20
var padding = 0

var colors : Array = [
	Color.BLUE ,
	Color.CHARTREUSE ,
	Color.WEB_PURPLE ,
]

@onready var brick_container: Marker2D = $BrickContainer
@onready var paddle: CharacterBody2D = %Paddle


func _ready() -> void:
	pass
	#start_grid()

func start_grid() -> void:
	'''Função para gerar um novo grid de bricks'''
	var bricks = Array()
	
	for line in range(rows):
		var line_array = []
		
		for col in range(columns):
			var new_brick = brick.instantiate()
			var pos = Vector2(
				col * brick_width,
				y_offset + line * brick_height
			)
			new_brick.position = pos
			print(new_brick.position)
			line_array.append(new_brick)
			brick_container.add_child(new_brick)
	
		bricks.append(line_array)
