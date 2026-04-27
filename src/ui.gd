extends Control

@onready var label_score: RichTextLabel = $VBoxContainer/Score
@onready var label_score_multiplier: RichTextLabel = $VBoxContainer/Multiplier/ScoreMultiplier
@onready var ball = get_node("/root/Game/SubViewport/Level1/Ball")

func _ready() -> void:
	ScoreCalculator.connect("update" , _update_text)

func _process(_delta: float) -> void:
	$VBoxContainer/Xvel.text = "vel : " + str(Vector2(ball.velocity))
	$VBoxContainer/Yvel.text = "multi : " + str(float(ball.velocity_multiplier))

func _update_text(game_score , game_multiplier):
	label_score.text = str(game_score)
	label_score_multiplier.text = str(game_multiplier) + " x"
