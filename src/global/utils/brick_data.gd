extends Node

var bricks_array : Array
var is_generating_grid = false
var is_grid_empty = true

var brick_colors : Array = [
	Color.RED ,
	Color.GREEN ,
	Color.BLUE ,
	Color.YELLOW
] 

var brick_types : Array = [
	"RED" ,
	"GREEN" ,
	"BLUE",
	"YELLOW"
]

var brick_powerups: Array = [
	"NORMAL",
	"SPEED",
	"WIDER_PADDLE",
	"MULTI_BALL"
]

func _check_brick_array():
	if bricks_array.size() > 0:
		is_grid_empty = false
	else:
		is_grid_empty = true
	return is_grid_empty
