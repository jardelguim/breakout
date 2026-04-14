extends Node

func _ready() -> void:
	InputManager.action_just_pressed.connect(_on_action_just_pressed)

func _on_action_just_pressed(action : String , _delta : float) -> void:
	match action:
		"escape":
			_quit_game()
			
	match action:
		"launch":
			_launch_ball()
			
func _launch_ball() -> void:
	print("Bola lançada")
	
func _quit_game():
	get_tree().quit()
