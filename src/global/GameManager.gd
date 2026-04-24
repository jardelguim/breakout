extends Node

signal update( game_score , game_multiplier )

var game_score : int = 0 : set = _set_game_score , get = _get_game_score
var game_multiplier : float = 1 : set = _set_game_multiplier , get = _get_game_multiplier

var brick_colors : Array = [
	Color.RED ,
	Color.GREEN ,
	Color.BLUE ,
]

var brick_types : Array = [
	"RED" ,
	"GREEN" ,
	"BLUE"
]

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

# Score Functions
func _set_game_score(value):
	game_score = value * game_multiplier
	print(game_score)
	update.emit(game_score , game_multiplier)

func _get_game_score():
	return game_score
	
func _set_game_multiplier(value):
	game_multiplier = value
	print(game_multiplier)
	update.emit(game_score, game_multiplier)

func _get_game_multiplier():
	return game_multiplier
