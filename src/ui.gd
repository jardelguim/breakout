extends Control

@onready var ball = get_node("/root/Game/SubViewport/Level1/Ball")
@onready var paddle = get_node("/root/Game/SubViewport/Level1/Paddle")
@onready var multiplier_fire_particles: GPUParticles2D = %MultiplierFireParticles
@onready var transitions_animation_player: AnimationPlayer = %TransitionsAnimationPlayer
@onready var label_score: RichTextLabel = %Score
@onready var label_quota: RichTextLabel = %Quota
@onready var label_score_multiplier: RichTextLabel = %ScoreMultiplier
@onready var speed_progress: ColorRect = %SpeedProgress
@onready var wider_progress: ColorRect = %WiderProgress
@onready var timer_label: RichTextLabel = %Timer
var can_play_animation_flag = true
var speed_time_left
var wider_time_left
var shake_rate = 20
var level = 5
var fire_rate = 0.0
var _high_scores_label: RichTextLabel

func _ready() -> void:
	_connect_game_manager_signals()
	transitions_animation_player.play_backwards("MenuFadeOut")
	await transitions_animation_player.animation_finished
	play_menu_animations()
	paddle.connect("speed_ended" , _on_paddle_speed_powerup_ended)
	paddle.connect("size_ended" , _on_paddle_size_powerup_ended)
	ScoreCalculator.connect("on_game_score_change" , _on_game_score_update)
	ScoreCalculator.connect("on_game_multiplier_change" , _on_game_multiplier_update)
	ScoreCalculator.connect("on_required_score_change", _on_game_required_score_update)
	
func _process(_delta: float) -> void:
	_animate_progress_bar()
	if GameManager.game_timer.is_stopped():
		timer_label.text = "%d" %GameManager.game_timer.wait_time
	else:	
		timer_label.text = "%d" %GameManager.game_timer.time_left
		
func _connect_game_manager_signals():
	GameManager.connect("level_clear" , _on_level_cleared)
	GameManager.connect("level_changed" , _on_level_changed)
	GameManager.connect("close_game" , _on_game_closed)
	GameManager.connect("game_over_signal" , _on_game_over)
	GameManager.connect("game_over_pressed" , _on_level_clear_pressed)
	GameManager.connect("ingame_pressed" , _on_ingame_pressed)
	GameManager.connect("level_clear_pressed", _on_level_clear_pressed)
	GameManager.connect("sec_over", on_sec_over)
	
	###### Buttons #######
	
func _on_start_button_pressed() -> void:
	transitions_animation_player.play("MenuFadeOut")
	SoundManager.play_selected_sound("menuSlidein")
	await transitions_animation_player.animation_finished
	$MainMenu.hide()
	transitions_animation_player.play("UiFadeOut")
	SoundManager.play_selected_sound("menuSlideout")
	await transitions_animation_player.animation_finished
	GameManager.GAME_STATE = GameManager.GAME_STATES.INGAME

func _on_exit_button_pressed() -> void:
	GameManager._quit_game()
	
func _on_ingame_pressed():
	SoundManager.play_selected_sound("menuSlideout")
	%PressAnimationPlayer.play("scale_down")
	can_play_animation_flag = false

func _on_level_clear_pressed():
	SoundManager.play_selected_sound("menuSlideout")
	%PressAnimationPlayer.play("scale_down")
	%ClearAnimationPlayer.play("scale_down")
	can_play_animation_flag = false
	
	###### Score ######
	
func _on_game_score_update(score):
	_play_score_animation()
	label_score.text = "%d" %score

func _on_game_multiplier_update(multiplier):
	_play_multi_animation()
	if ScoreCalculator.multiplier != 2.5:
		SoundManager.play_selected_sound("generic1")
	shake_rate = clamp((multiplier - 1)/1.5 * 50, 0 , 50)
	multiplier_fire_particles.amount_ratio = clamp(multiplier - 1.5 , 0.0 , 1.0)
	level = clamp(multiplier/2.5 * 40, 5, 40)
	label_score_multiplier.text = "[shake rate=%s level=%s connected=1]%s[/shake]" %[shake_rate , level , multiplier]

func _on_game_required_score_update(required_score):
	_play_quota_animation()
	label_quota.text = "%d" %required_score

###### Animations ######	
func _play_quota_animation():
	var quota_animations : Array = [
		"quota_add1",
		"quota_add2"
	]
	%QuotaAnimationPlayer.play(quota_animations.pick_random())
	
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
	
func _animate_progress_bar():
	speed_time_left = float(paddle.get_node("SpeedTimer").time_left)
	wider_time_left = float(paddle.get_node("WiderTimer").time_left)
	var tween = create_tween()
	tween.tween_property(
		speed_progress.material,
		"shader_parameter/progress" ,
		speed_time_left/10.0 , 0.1).set_ease(Tween.EASE_IN)
	tween.tween_property(
		wider_progress.material, 
		"shader_parameter/progress" , 
		wider_time_left/10.0 , 0.1).set_ease(Tween.EASE_IN)

func _on_paddle_size_powerup() -> void:
	var tween = create_tween()
	tween.tween_property(%WiderIcon , "scale" , Vector2(1.0 , 1.0) , 0.2).set_ease(Tween.EASE_IN)
	

func _on_paddle_speed_powerup() -> void:
	var tween = create_tween()
	tween.tween_property(%SpeedIcon , "scale" , Vector2(1.0 , 1.0) , 0.2).set_ease(Tween.EASE_IN)

func _on_paddle_size_powerup_ended() -> void:
	var tween = create_tween()
	tween.tween_property(%WiderIcon , "scale" , Vector2(0 , 0) , 0.2).set_ease(Tween.EASE_OUT)
	
func _on_paddle_speed_powerup_ended() -> void:
	var tween = create_tween()
	tween.tween_property(%SpeedIcon , "scale" , Vector2(0 , 0) , 0.2).set_ease(Tween.EASE_OUT)

func play_menu_animations():
	%MenuAnimations.play("game_title_pop_in")
	await %MenuAnimations.animation_finished
	%MenuAnimations.play("start_pop_in")
	await %MenuAnimations.animation_finished
	%MenuAnimations.play("exit_pop_in")
	await %MenuAnimations.animation_finished
	
	#### Game state events ####
	
func _on_level_changed(level):
	%LevelLabel.text = str(level)

func _on_level_cleared():
	SoundManager.play_selected_sound("menuSlidein")
	%ClearAnimationPlayer.play("scale_up")
	%ClearLabel.text = "[wave amp=50.0 freq=5.0 connected=1]LEVEL CLEAR[/wave]"
	%PressLabel.text = "[wave amp=50.0 freq=5.0 connected=1]PRESS SPACE
TO CONTINUE[/wave]"
	await %ClearAnimationPlayer.animation_finished
	%PressAnimationPlayer.play("scale_up")
	await %PressAnimationPlayer.animation_finished
	can_play_animation_flag = true
	
func _on_game_over():
	SoundManager.play_selected_sound("menuSlidein")
	%ClearAnimationPlayer.play("scale_up")
	%ClearLabel.text = "[wave amp=50.0 freq=5.0 connected=1]GAME OVER[/wave]"
	%PressLabel.text = "[wave amp=50.0 freq=5.0 connected=1]PRESS SPACE
TO RETRY[/wave]"
	HighScoreManager.add_score(ScoreCalculator.score, GameManager.level)
	_refresh_high_scores_label()
	await %ClearAnimationPlayer.animation_finished
	%PressAnimationPlayer.play("scale_up")
	can_play_animation_flag = true
	
func _on_game_closed():
	transitions_animation_player.play_backwards("UiFadeOut")
	SoundManager.play_selected_sound("menuSlidein")
	
func on_sec_over():
	if GameManager.game_timer.is_stopped():
		return
	if GameManager.game_timer.time_left <= 10.0:
		%TimerAnimationPlayer.play("tick")
		SoundManager.play_selected_sound("timer")

func _refresh_high_scores_label() -> void:
	var top = HighScoreManager.get_top_scores(5)
	var text = "HIGH SCORES\n"
	var marker = ""
	for i in top.size():
		var entry = top[i]
		text += "%d.  %d  (lv %d) \n" %[i + 1, entry["score"], entry["level"]]
	if top.is_empty():
		text += "-"
	%HighScoreText.text = text
