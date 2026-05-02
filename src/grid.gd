extends Node2D

const max_rows = 7
const max_columns = 20
const max_screen_size = 320
@export var columns : int = 20
@export var rows : int = 6
@export var brick : PackedScene
var brick_height = 15
var brick_width = 15
var left_screen_offset = 0
var y_offset = 15

@onready var brick_container: Marker2D = $BrickContainer
@onready var paddle: CharacterBody2D = %Paddle

func start_grid() -> void:
	'''Function to generate a new grid'''
	if BrickData.is_generating_grid == true:
		return
	BrickData.is_generating_grid = true
	
	var tween = create_tween()
	
	# Generate Grid
	columns = randf_range(4 , max_columns)
	rows = randf_range(4 , max_rows)
	var x_offset = 18 + ((brick_width * (max_columns - columns)/2))
	
	for line in range(rows):
		#var line_brick_type = BrickData.brick_types.pick_random()
		for col in range(columns):
			var new_brick = brick.instantiate()
			
			# Set brick position
			var pos = Vector2(
				left_screen_offset + (col * brick_width + x_offset),
				y_offset + line * brick_height
			)
			# Set brick type
			new_brick.brick_type ="YELLOW"
			new_brick.set_brick_type()	
			new_brick.position = pos
			new_brick.power_up_event.connect(GameManager.on_powerup_event)
			
			BrickData.bricks_array.append(new_brick)
			brick_container.add_child(new_brick)
			
			# Animate the brick
			tween.tween_property(new_brick , "modulate:a" , 1 , 0.01)
			
	await tween.finished
	BrickData.is_generating_grid = false
