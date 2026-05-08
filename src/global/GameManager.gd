extends Node

@onready var ball = get_node("/root/Game/SubViewport/Level1/Ball")
@onready var paddle = get_node("/root/Game/SubViewport/Level1/Paddle")
@onready var grid = get_node("/root/Game/SubViewport/Level1/Grid")

var screen_center : Vector2 = Vector2(320 , 320) / 2
var speed_timer = Timer.new()
var game_started = false
var level = 1

func _ready() -> void:
	self.process_mode = self.PROCESS_MODE_ALWAYS
	InputManager.action_just_pressed.connect(_on_action_just_pressed)
	speed_timer.timeout.connect(speed_over)
	add_child(speed_timer)
	ball.position = screen_center
	
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
	ball.switch_active_state()
	
func generate_grid():
	grid.start_grid()
	
func start_game():
	if not BrickData.is_grid_empty:
		return
	grid.start_grid()
	BrickData.is_grid_empty = false
	ball.position = screen_center
	
func _quit_game():
	get_tree().quit()
	
func toggle_pause_game():
	get_tree().paused = !get_tree().paused

func speed_over():
	paddle.base_speed = 300

func on_powerup_event(powerup_type: String):
	print("Event: ", powerup_type)
	match powerup_type:
		"NORMAL":
			pass
		"SPEED":
			speed_timer.start(5)
			paddle.base_speed = clamp(paddle.base_speed + 100, 300, 500)
