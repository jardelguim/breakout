extends Control

@onready var label_score: RichTextLabel = %Score
@onready var label_score_multiplier: RichTextLabel = %ScoreMultiplier
@onready var ball = get_node("/root/Game/SubViewport/Level1/Ball")
@onready var label: Label = $Label

func _process(delta: float) -> void:
	label.text = str(ball.velocity)
func _ready() -> void:
	ScoreCalculator.connect("update" , _update_text)

func _update_text(game_score , game_multiplier):
	label_score.text = str(game_score)
	label_score_multiplier.text = str(game_multiplier) + "x"

func _on_start_button_pressed() -> void:
	$MainMenu.hide()
