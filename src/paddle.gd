extends Area2D

@export var SPEED := 250.0

func _ready() -> void:
	InputManager.action_pressed.connect(_on_action_pressed)

func _physics_process(delta: float) -> void:
	var direction = InputManager.get_paddle_direction()
	position.x += direction * SPEED * get_physics_process_delta_time()
	_clamp_position()

func _on_action_pressed(action: String) -> void:
	match action:
		"launch":
			_launch_ball()

func _launch_ball() -> void:
	pass

func _clamp_position() -> void:
	var half_width: float = $CollisionShape2D.shape.size.x / 2.0
	var screen_width := get_viewport_rect().size.x
	position.x = clamp(position.x, half_width, screen_width - half_width)
