extends Node2D

@onready var grid: Node2D = $Grid

func _process(_delta: float) -> void:
	pass

func _ready() -> void:
	grid.start_grid()

	
