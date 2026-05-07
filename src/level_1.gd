extends Node2D

@onready var level_timer: Timer = $LevelTimer

func set_level_timer(value):
	level_timer.wait_time = value

func _on_level_timer_timeout() -> void:
	pass # Replace with function body.
