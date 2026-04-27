extends Node

@onready var ball = get_node("/root/Game/SubViewport/Level1/Ball")

var bricks_array : Array : set = _set_brick_array

var brick_colors : Array = [
	Color.RED ,
	Color.GREEN ,
	Color.BLUE ,
	Color.YELLOW
] 

var brick_types : Array = [
	"RED" ,
	"GREEN" ,
	"BLUE",
	"YELLOW"
]

func _ready() -> void:
	InputManager.action_just_pressed.connect(_on_action_just_pressed)

func _on_action_just_pressed(action : String , _delta : float) -> void:
	match action:
		"escape":
			_quit_game()
		"launch":
			_launch_ball()

func _launch_ball() -> void:
	ball.switch_active_state()
	
func _quit_game():
	get_tree().quit()

func _set_brick_array(value):
	print(value)
