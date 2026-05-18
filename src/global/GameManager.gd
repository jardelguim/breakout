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

signal level_changed(level)

var game_timer = Timer.new()
var screen_center : Vector2 = Vector2(320 , 320) / 2
var game_started = false
var level = 1

func _ready() -> void:
	add_child(game_timer)
	game_timer.wait_time = 10.0
	game_timer.one_shot = true
	game_timer.connect("timeout" , game_over)
	self.process_mode = self.PROCESS_MODE_ALWAYS
	InputManager.action_just_pressed.connect(_on_action_just_pressed)

func _on_action_just_pressed(action : String , _delta : float) -> void:
	match action:
		"escape":
			_quit_game()
		"launch":
			_launch_ball()

func _launch_ball() -> void:
	if BrickData.is_generating_grid:
		return
	if game_started:
		return
	if ball.is_active:
		return
	game_timer.start()
	ball.enable_ball()
	
func generate_grid():
	grid.start_grid()
	
func start_game():
	if not BrickData.is_grid_empty:
		return
	grid.start_grid()
	BrickData.is_grid_empty = false
	ball.position = screen_center

func game_over():
	ball.game_over()
	print("Game is over")

func _quit_game():
	get_tree().quit()
	
func toggle_pause_game():
	get_tree().paused = !get_tree().paused
