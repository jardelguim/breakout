extends Node

signal on_game_score_change(score)
signal on_game_multiplier_change(multiplier)

var multiplier: float = 1.0: set = _on_multiplier_set
var multiplier_limit: float = 2.5
var score: int = 0: set = _on_score_set
var required_score : int = 70: set = _on_required_score_set

func _on_multiplier_set(value):
	multiplier = value
	on_game_multiplier_change.emit(value)

func _on_score_set(value):
	score = value
	on_game_score_change.emit(int(value))
	
func _on_required_score_set(value):
	required_score = value

func reset_chain():
	multiplier = 1.0

func add_score_with_multiplication(base_score: int):
	score += base_score * multiplier

func add_multiplier(multifactor: float = 0.1):
	multiplier = clamp(multifactor + multiplier, 1.0, multiplier_limit)

func add_score_and_multiply(base_score, multifactor):
	add_score_with_multiplication(base_score)
	add_multiplier(multifactor)
	
