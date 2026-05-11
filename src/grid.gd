extends Node2D

@export var brick : PackedScene
const max_rows = 8
const max_columns = 20
const max_screen_size = 320
var columns : int = 10
var rows : int = 4
var brick_height = 15
var brick_width = 15
var left_screen_offset = 0
var y_offset = 15

func _on_brick_hit(is_alive):
	var powerup = GameManager.powerups["increase_paddle"]
	if not is_alive:
		return
	powerup.activate()

func start_grid() -> void:
	'''Function to generate a new grid'''
	if BrickData.is_generating_grid == true:
		return
	BrickData.is_generating_grid = true
	
	var tween = create_tween()
	
	# Generate Grid
	columns = clamp(columns + GameManager.level , 10 , max_columns)
	rows = clamp(rows + GameManager.level , 4 , max_rows)
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
			new_brick.brick_type = BrickData.brick_types.pick_random()
			new_brick.set_brick_type()	
			new_brick.position = pos

			BrickData.bricks_array.append(new_brick)
			$BrickContainer.add_child(new_brick)
			
			# Animate the brick
			tween.tween_property(new_brick , "modulate:a" , 1 , 0.01)
			
	await tween.finished
	BrickData.is_generating_grid = false
