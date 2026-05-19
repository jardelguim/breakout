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
	LEVEL_CLEAR
}
var GAME_STATE : GAME_STATES

signal space_pressed
signal level_changed(level)

var game_timer = Timer.new()
var screen_center : Vector2 = Vector2(320 , 320) / 2
var game_started = false
var level = 1

func _ready() -> void:
	GAME_STATE = GAME_STATES.MAIN_MENU
	add_child(game_timer)
	game_timer.wait_time = 60.0
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

func _space_pressed() -> void:
	print(GAME_STATE)
	print(ball.is_active)
	print(BrickData.is_generating_grid)
	print(BrickData.is_grid_empty)
	if GAME_STATE != GAME_STATES.INGAME:
		return
	if ball.is_active:
		return
	if BrickData.is_grid_empty:
		space_pressed.emit()
		_generate_grid()
	if BrickData.is_generating_grid == false:
		ball.enable_ball()
		game_timer.start()
	
func _generate_grid():
	grid.start_grid()
	
func delete_all_bricks():
	while BrickData.bricks_array.size() > 0:
		var first_brick = BrickData.bricks_array[-1]
		await get_tree().create_timer(0.1).timeout
		var x = randf_range(-1.0 , 1.0)
		var y = randf_range(-1.0 , 1.0)
		first_brick.hit(Vector2( x , y) , randf_range(1.0 , 5.0) , false)
	ScoreCalculator

func time_over():
	#GAME_STATE = GAME_STATES.TIME_OVER
	ball.time_over()
	if ScoreCalculator.score >= ScoreCalculator.required_score:
		delete_all_bricks()
		print("Level clear")
	print("Game is over")

func _quit_game():
	get_tree().quit()
	
func toggle_pause_game():
	get_tree().paused = !get_tree().paused
