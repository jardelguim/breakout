extends Node

const SAVE_PATH = "res://high_scores.json"
const MAX_SCORES = 10

var scores: Array = []

func _ready() -> void:
	load_scores()

func add_score(score: int, level: int) -> int:
	var date = Time.get_date_string_from_system()
	var entry = {"score": score, "level": level, "date": date}
	scores.append(entry)
	scores.sort_custom(func(a, b): return a["score"] > b["score"])
	if scores.size() > MAX_SCORES:
		scores.resize(MAX_SCORES)
	save_scores()
	for i in scores.size():
		if scores[i]["score"] == score and scores[i]["date"] == date:
			return i
	return -1

func get_top_scores(count: int = 10) -> Array:
	return scores.slice(0, min(count, scores.size()))

func is_high_score(score: int) -> bool:
	if scores.size() < MAX_SCORES:
		return true
	return score > scores[-1]["score"]

func save_scores() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(scores, "\t"))
		file.close()

func load_scores() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		scores = []
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		scores = []
		return
	var content = file.get_as_text()
	file.close()
	var result = JSON.parse_string(content)
	if result is Array:
		scores = result
	else:
		scores = []
