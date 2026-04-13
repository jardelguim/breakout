extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var grid: Node2D = $Grid

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	grid.start_grid()

	
