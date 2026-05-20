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

enum GAME_STATES {
	MAIN_MENU,
	INGAME,
	PAUSED,
	TIME_OVER,
	LEVEL_CLEAR,
	GAME_OVER
}

var GAME_STATE : GAME_STATES

signal level_clear(level)
signal space_pressed

var game_timer = Timer.new()
var game_wait_time = 10
var screen_center : Vector2 = Vector2(320 , 320) / 2
var game_started = false
var level = 1

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

##### STATE FUNCTIONS #####

func _set_state(new_state: GAME_STATES) ->void:
	if new_state == GAME_STATE:
		return
	
	GAME_STATE = new_state
	
	match GAME_STATE:
		GAME_STATES.PAUSED:
			get_tree().paused = !get_tree().paused
		GAME_STATES.LEVEL_CLEAR:
			level_cleared()
		GAME_STATES.GAME_OVER:
			print("Game over")
		GAME_STATES.TIME_OVER:
			ball.time_over()
			await delete_all_bricks()
			if ScoreCalculator.score >= ScoreCalculator.required_score:
				_set_state(GAME_STATES.LEVEL_CLEAR)
			else:
				_set_state(GAME_STATES.GAME_OVER)
	
func level_cleared():
	level += 1
	ScoreCalculator._on_level_changed()
	level_clear.emit(level)

func _space_pressed() -> void:
	print("Game_state: %d" %GAME_STATE)
	print("Ball.is_active: %s" %ball.is_active)
	print("BrickData.is_generating_grid: %s" %BrickData.is_generating_grid)
	print("BrickData.is_grid_empty: %s" %BrickData.is_grid_empty)
	if GAME_STATE == GAME_STATES.LEVEL_CLEAR:
		_set_state(GAME_STATES.INGAME)
	if GAME_STATE != GAME_STATES.INGAME:
		return
	if ball.is_active:
		return
	if BrickData.is_grid_empty:
		space_pressed.emit()
		_generate_grid()
	
func _generate_grid():
	grid.start_grid()
	
func delete_all_bricks():
	while BrickData.bricks_array.size() > 0:
		var first_brick = BrickData.bricks_array[-1]
		first_brick.count_points = false
		await get_tree().create_timer(0.1).timeout
		var x = randf_range(-1.0 , 1.0)
		var y = randf_range(-1.0 , 1.0)
		first_brick.hit(Vector2( x , y) , randf_range(1.0 , 5.0) , false)
	
func start_game():
	ball.enable_ball()
	game_timer.start()
	
func time_over():
	_set_state(GAME_STATES.TIME_OVER)
	
func _quit_game():
	get_tree().quit()

func toggle_pause_game():
	_set_state(GAME_STATES.PAUSED)
	
