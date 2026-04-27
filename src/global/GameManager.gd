extends Node

@onready var ball = get_node("/root/Game/SubViewport/Level1/Ball")


func _ready() -> void:
	InputManager.action_just_pressed.connect(_on_action_just_pressed)

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
	
