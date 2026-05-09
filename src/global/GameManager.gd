extends Node

@onready var ball = get_node("/root/Game/SubViewport/Level1/Ball")
@onready var paddle = get_node("/root/Game/SubViewport/Level1/Paddle")
@onready var grid = get_node("/root/Game/SubViewport/Level1/Grid")

var screen_center : Vector2 = Vector2(320 , 320) / 2
var game_started = false
var level = 1

func _ready() -> void:
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

func on_powerup_event(powerup_type: String):
	print("Event: ", powerup_type)
	match powerup_type:
		"NORMAL":
			pass
		"SPEED":
			paddle.speed_up()
		"WIDER_PADDLE":
			paddle.wider_paddle()
		"MULTI_BALL":
			return
			#var new_ball = preload("res://scenes/ball.tscn").instantiate()
			#new_ball.position = ball.position
			#new_ball.scale = Vector2(0.7, 0.7)
			#ball.get_parent().add_child(new_ball)
			#ball.launch_with_direction(Vector2(randf_range(-1.0, -0.3), -1.0))
			#new_ball.launch_with_direction(Vector2(randf_range(0.3, 1.0), -1.0))
