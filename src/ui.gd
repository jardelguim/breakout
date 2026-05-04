extends Control

@onready var label_score: RichTextLabel = %Score
@onready var label_score_multiplier: RichTextLabel = %ScoreMultiplier
@onready var ball = get_node("/root/Game/SubViewport/Level1/Ball")
@onready var label: Label = $Label
@onready var multiplier_fire_particles: GPUParticles2D = %MultiplierFireParticles
var shake_rate = 20
var level = 5
var fire_rate = 0.0

func _process(delta: float) -> void:
	label.text = str(ball.velocity)
	
func _ready() -> void:
	ScoreCalculator.connect("on_game_score_change" , _on_game_score_update)
	ScoreCalculator.connect("on_game_multiplier_change" , _on_game_multiplier_update)

func _on_start_button_pressed() -> void:
	$MainMenu.hide()

func _on_game_score_update(score):
	_play_score_animation()
	label_score.text = str(score)

func _on_game_multiplier_update(multiplier):
	_play_multi_animation()
	shake_rate = clamp((multiplier - 1)/1.5 * 50, 0 , 50)
	multiplier_fire_particles.amount_ratio = clamp(multiplier - 1.5 , 0.0 , 1.0)
	level = clamp(multiplier/2.5 * 40, 5, 40)
	label_score_multiplier.text = "[shake rate=%s level=%s connected=1]%sx[/shake]" %[shake_rate , level , multiplier]

#func _update_text(game_score , game_multiplier):
	#print("multiplicador:%s" %game_multiplier)
	#print("shake rate:%s" %shake_rate)
	#print("fire amount:%s" %multiplier_fire_particles.amount_ratio)
	#print("level:%s" %level)
	#var game_multiplier_percentage = game_multiplier/2.5
	#_play_multi_animation()
	#_play_score_animation()
	#shake_rate = clamp((game_multiplier - 1)/1.5 * 50, 0 , 50)
	#multiplier_fire_particles.amount_ratio = clamp(game_multiplier - 1.5 , 0.0 , 1.0)
	#level = clamp(game_multiplier_percentage * 40, 5, 40)
	#label_score.text = str(game_score)
	#label_score_multiplier.text = "[shake rate=%s level=%s connected=1]%sx[/shake]" %[shake_rate , level , game_multiplier]

func _play_multi_animation():
	var multi_animations : Array = [
		"multi_add1",
		"multi_add2"
	]
	%MultiAnimationPlayer.play(multi_animations.pick_random())
	
func _play_score_animation():
	var score_animations : Array = [
		"score_add1",
		"score_add2"
	]
	%ScoreAnimationPlayer.play(score_animations.pick_random())
