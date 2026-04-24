extends Control

@onready var label_score: RichTextLabel = $VBoxContainer/Score
@onready var label_score_multiplier: RichTextLabel = $VBoxContainer/Multiplier/ScoreMultiplier
@onready var ball = get_node("/root/Game/SubViewport/Level1/Ball")

func _ready() -> void:
	GameManager.connect("update" , _update_text)
	
func _process(delta: float) -> void:
	$VBoxContainer/Xvel.text = "X : " + str(int(ball.velocity.x))
	$VBoxContainer/Yvel.text = "Y : " + str(int(ball.velocity.y))

func _update_text(game_score , game_multiplier):
	label_score.text = str(game_score)
	label_score_multiplier.text = str(game_multiplier) + " x"
