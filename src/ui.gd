extends Control

@onready var ball = get_node("/root/Game/SubViewport/Level1/Ball")
@onready var paddle = get_node("/root/Game/SubViewport/Level1/Paddle")
@onready var multiplier_fire_particles: GPUParticles2D = %MultiplierFireParticles
@onready var transitions_animation_player: AnimationPlayer = %TransitionsAnimationPlayer
@onready var label_score: RichTextLabel = %Score
@onready var label_score_multiplier: RichTextLabel = %ScoreMultiplier
@onready var speed_progress: ColorRect = %SpeedProgress
@onready var wider_progress: ColorRect = %WiderProgress
var speed_time_left
var wider_time_left
var shake_rate = 20
var level = 5
var fire_rate = 0.0

func _ready() -> void:
	transitions_animation_player.play_backwards("MenuFadeOut")
	paddle.connect("speed_ended" , _on_paddle_speed_powerup_ended)
	paddle.connect("size_ended" , _on_paddle_size_powerup_ended)
	GameManager.connect("level_changed" , _on_level_change)
	ScoreCalculator.connect("on_game_score_change" , _on_game_score_update)
	ScoreCalculator.connect("on_game_multiplier_change" , _on_game_multiplier_update)
	
func _process(_delta: float) -> void:
	speed_time_left = float(paddle.get_node("SpeedTimer").time_left)
	wider_time_left = float(paddle.get_node("WiderTimer").time_left)
	var tween = create_tween()
	tween.tween_property(speed_progress.material, "shader_parameter/progress" , speed_time_left/10.0 , 0.1).set_ease(Tween.EASE_IN)
	tween.tween_property(wider_progress.material, "shader_parameter/progress" , wider_time_left/10.0 , 0.1).set_ease(Tween.EASE_IN)
	
	###### Buttons #######
	
func _on_start_button_pressed() -> void:
	transitions_animation_player.play("MenuFadeOut")
	await transitions_animation_player.animation_finished
	$MainMenu.hide()
	transitions_animation_player.play("UiFadeOut")
	await transitions_animation_player.animation_finished
	GameManager.generate_grid()
	
	###### Animations ######
	
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
	
	###### Score ######
	
func _on_game_score_update(score):
	_play_score_animation()
	label_score.text = str(score)

func _on_game_multiplier_update(multiplier):
	_play_multi_animation()
	if ScoreCalculator.multiplier != 2.5:
		SoundManager.play_selected_sound("generic1")
	shake_rate = clamp((multiplier - 1)/1.5 * 50, 0 , 50)
	multiplier_fire_particles.amount_ratio = clamp(multiplier - 1.5 , 0.0 , 1.0)
	level = clamp(multiplier/2.5 * 40, 5, 40)
	label_score_multiplier.text = "[shake rate=%s level=%s connected=1]%sx[/shake]" %[shake_rate , level , multiplier]

func _on_paddle_size_powerup() -> void:
	$IconsAnimationPlayer.play("size_scale_up")

func _on_paddle_speed_powerup() -> void:
	$IconsAnimationPlayer.play("speed_scale_up")

func _on_paddle_size_powerup_ended() -> void:
	$IconsAnimationPlayer.play_backwards("size_scale_up")
	
func _on_paddle_speed_powerup_ended() -> void:
	$IconsAnimationPlayer.play_backwards("speed_scale_up")

func _on_level_change(level):
	%LevelLabel.text = str(level)
