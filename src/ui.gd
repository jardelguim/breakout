extends Control

@onready var label_score: RichTextLabel = $VBoxContainer/Score
@onready var label_score_multiplier: RichTextLabel = $VBoxContainer/Multiplier/ScoreMultiplier


func _ready() -> void:
	GameManager.connect("update" , _update_text)
	
func _update_text(game_score , game_multiplier):
	label_score.text = str(game_score)
	label_score_multiplier.text = str(game_multiplier)
