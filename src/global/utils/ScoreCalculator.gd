extends Node

signal update(score, multiplier)

var multiplier: float = 1.0
var multiplier_limit: float = 10.0
var score: int = 0

func reset_chain():
	multiplier = 1.0
	update.emit(score, multiplier)

func add_score_with_multiplication(base_score: int):
	score += base_score * multiplier
	update.emit(score, multiplier)

func add_multiplier(multifactor: float = 0.1):
	multiplier = clamp(multifactor + multiplier, 1.0, multiplier_limit)
	update.emit(score, multiplier)

func add_score_and_multiply(base_score, multifactor):
	add_score_with_multiplication(base_score)
	add_multiplier(multifactor)
