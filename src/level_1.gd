extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@export var grid_size_x = 4
@export var grid_size_y = 4

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	_generate_bricks()
	
func _generate_bricks() -> void:
	for x in grid_size_x:
		for y in grid_size_y:
			tile_map_layer.set_cell(Vector2i(x , y))
	
