extends Node

@onready var ball = get_node("/root/Game/SubViewport/Level1/Ball")
@onready var paddle = get_node("/root/Game/SubViewport/Level1/Paddle")
@onready var grid = get_node("/root/Game/SubViewport/Level1/Grid")
@onready var level_node = get_node("/root/Game/SubViewport/Level1")
@onready var powerups: Dictionary[String, PowerUp] = {
	"speed_up": SpeederPowerUp.new(paddle),
	"increase_paddle": IncreasePaddlePowerUp.new(paddle),
	"explosion": ExplosionPowerUp.new(level_node)
}
var game_timer = Timer.new()
var game_wait_time = 60
var screen_center : Vector2 = Vector2(320 , 320) / 2
var level = 1 : set = _on_level_changed

signal level_changed(level)
signal level_clear
signal level_clear_pressed
signal game_over_signal
signal game_over_pressed
signal ingame_pressed
#signal game_started
signal close_game

var GAME_STATE : GAME_STATES
enum GAME_STATES {
	MAIN_MENU,
	INGAME,
	PAUSED,
	TIME_OVER,
	LEVEL_CLEAR,
	GAME_OVER,
	RUNNING
}

func _ready() -> void:
	_set_state(GAME_STATES.MAIN_MENU)
	add_child(game_timer)
	game_timer.wait_time = game_wait_time
	game_timer.one_shot = true
	game_timer.connect("timeout" , time_over)
	self.process_mode = self.PROCESS_MODE_ALWAYS
	InputManager.action_just_pressed.connect(_on_action_just_pressed)

func _on_action_just_pressed(action : String , _delta : float) -> void:
	match action:
		"escape":
			_quit_game()
		"launch":
			_space_pressed()

func _set_state(new_state: GAME_STATES) ->void:
	if new_state == GAME_STATE:
		return
	
	GAME_STATE = new_state
	
	match GAME_STATE:
		GAME_STATES.PAUSED:
			get_tree().paused = !get_tree().paused
		GAME_STATES.INGAME:
			print("Ingame!")
			start_game()
			_set_state(GAME_STATES.RUNNING)
		GAME_STATES.RUNNING:
			print("Running!")
		GAME_STATES.LEVEL_CLEAR:
			print("Level Clear")
			level_cleared()
		GAME_STATES.GAME_OVER:
			print("Game Over")
			game_over()
		GAME_STATES.TIME_OVER:
			print("Time Over")
			ball.time_over()
			await delete_all_bricks()
			if ScoreCalculator.score >= ScoreCalculator.required_score:
				print("Score reached")
				_set_state(GAME_STATES.LEVEL_CLEAR)
			else:
				print("Score not reached")
				_set_state(GAME_STATES.GAME_OVER)
	
func level_cleared():
	level_clear.emit()

func game_over():
	game_over_signal.emit()
	grid.reset_grid_size()

func _space_pressed() -> void:
	#print("Game_state: %d" %GAME_STATE)
	#print("Ball.is_active: %s" %ball.is_active)
	#print("BrickData.is_generating_grid: %s" %BrickData.is_generating_grid)
	#print("BrickData.is_grid_empty: %s" %BrickData.is_grid_empty)
	match GAME_STATE:
		GAME_STATES.LEVEL_CLEAR:
			level_clear_pressed.emit()
			level += 1
			ScoreCalculator._on_level_changed()
			await get_tree().create_timer(1.0).timeout
			_set_state(GAME_STATES.INGAME)
		GAME_STATES.GAME_OVER:
			game_over_pressed.emit()
			reset_game()
			await get_tree().create_timer(1.0).timeout
			_set_state(GAME_STATES.INGAME)
		GAME_STATES.INGAME:
			ingame_pressed.emit()
			start_game()
			_set_state(GAME_STATES.RUNNING)
	
func delete_all_bricks():
	while BrickData.bricks_array.size() > 0:
		var first_brick = BrickData.bricks_array[-1]
		first_brick.count_points = false
		await get_tree().create_timer(0.1).timeout
		var x = randf_range(-1.0 , 1.0)
		var y = randf_range(-1.0 , 1.0)
		first_brick.hit(Vector2( x , y) , randf_range(1.0 , 5.0) , false)
		SoundManager.play_sound(first_brick.object_sound)
	
func reset_game():
	level = 1
	print("Game level reseted")
	print("Game level: %d" %level)
	ScoreCalculator.reset_score()
	start_game()
	
func start_game():
	print("Game started")
	grid.start_grid()
	await grid.grid_generated
	ball.enable_ball()
	game_timer.wait_time = game_wait_time
	game_timer.start()
	#game_started.emit()
	
func time_over():
	_set_state(GAME_STATES.TIME_OVER)
	
func _quit_game():
	close_game.emit()
	await get_tree().create_timer(0.7).timeout
	get_tree().quit()

func toggle_pause_game():
	_set_state(GAME_STATES.PAUSED)
	
func _on_level_changed(value):
	level = value
	level_changed.emit(level)
	
func on_bricks_cleared():
	pass
	#game_timer.wait_time = 0.0
