extends Node

@onready var ball = get_node("/root/Game/SubViewport/Level1/Ball")
@onready var paddle = get_node("/root/Game/SubViewport/Level1/Paddle")
@onready var grid = get_node("/root/Game/SubViewport/Level1/Grid")

var screen_center : Vector2 = Vector2(320 , 320) / 2
var speed_timer = Timer.new()
var game_started = false
var level = 1

func _ready() -> void:
	toggle_pause_game()
	InputManager.action_just_pressed.connect(_on_action_just_pressed)
	speed_timer.timeout.connect(speed_over)
	add_child(speed_timer)
	ball.position = screen_center
	
func _on_action_just_pressed(action : String , _delta : float) -> void:
	match action:
		"escape":
			_quit_game()
		"launch":
			start_game()

func _launch_ball() -> void:
	if BrickData.is_generating_grid:
		return
	if game_started == true:
		return
	if ball.is_active:
		return
	ball.switch_active_state()
	
func grid_generated():
	_launch_ball()
	
func start_game():
	if not BrickData.is_grid_empty:
		return
	grid.start_grid()
	BrickData.is_grid_empty = false
	ball.position = screen_center
	
func _quit_game():
	get_tree().quit()
	
func toggle_pause_game():
	get_tree().paused != get_tree().paused

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
		"WIDER_PADDLE":
			paddle.scale = Vector2(1.5, 1.0)
			var paddle_timer = Timer.new()
			paddle_timer.timeout.connect(func(): 
				paddle.scale = Vector2(1.0, 1.0)
			)
			add_child(paddle_timer)
			paddle_timer.start(7)
		"MULTI_BALL":
			var new_ball = preload("res://scenes/ball.tscn").instantiate()
			new_ball.position = ball.position
			new_ball.scale = Vector2(0.7, 0.7)
			ball.get_parent().add_child(new_ball)
			ball.launch_with_direction(Vector2(randf_range(-1.0, -0.3), -1.0))
			new_ball.launch_with_direction(Vector2(randf_range(0.3, 1.0), -1.0))
