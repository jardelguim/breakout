extends Node

signal on_game_score_change(score)
signal on_game_multiplier_change(multiplier)
signal on_required_score_change(required_score)

var multiplier: float = 1.0: set = _on_multiplier_set
var multiplier_limit: float = 2.5
var score: int = 0: set = _on_score_set
var required_score : int = 500: set = _on_required_score_set
var level: int = 1


func _on_multiplier_set(value):
	multiplier = value
	on_game_multiplier_change.emit(value)

func _on_score_set(value):
	score = value
	on_game_score_change.emit(int(value))
	
func _on_required_score_set(value):
	required_score = value
	on_required_score_change.emit(int(required_score))

func reset_chain():
	multiplier = 1.0

func reset_score():
	reset_chain()
	score = 0
	required_score = 80

func add_score_with_multiplication(base_score: int):
	score += base_score * multiplier

func add_multiplier(multifactor: float = 0.1):
	multiplier = clamp(multifactor + multiplier, 1.0, multiplier_limit)

func add_score_and_multiply(base_score, multifactor):
	add_score_with_multiplication(base_score)
	add_multiplier(multifactor)
	
func _on_level_changed():
	var base_increment = 120
	var level_multiplier = level * 0.2
	required_score = score + base_increment + int(level_multiplier * base_increment)
	print("NEW REQUIRED SCORE: ", required_score)
