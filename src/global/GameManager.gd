extends Node

@onready var ball = get_node("/root/Game/SubViewport/Level1/Ball")
@onready var paddle = get_node("/root/Game/SubViewport/Level1/Paddle")
var speed_timer = Timer.new()


func _ready() -> void:
	InputManager.action_just_pressed.connect(_on_action_just_pressed)
	speed_timer.timeout.connect(speed_over)
	add_child(speed_timer)

func _on_action_just_pressed(action : String , _delta : float) -> void:
	match action:
		"escape":
			_quit_game()
		"launch":
			_launch_ball()

func _launch_ball() -> void:
	print(BrickData.is_generating_grid)
	if BrickData.is_generating_grid:
		return
	ball.switch_active_state()
	
func _quit_game():
	get_tree().quit()
	
func toggle_pause_game():
	get_tree().paused != get_tree().paused

func speed_over():
	paddle.SPEED = 200

func on_powerup_event(powerup_type: String):
	print("Event: ", powerup_type)
	match powerup_type:
		"NORMAL":
			pass
		"SPEED":
			speed_timer.start(5)
			paddle.SPEED = clamp(paddle.SPEED + 200, 200, 600)
