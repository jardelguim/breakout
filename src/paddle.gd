extends CharacterBody2D

@export var SPEED := 250.0

func _ready() -> void:
	InputManager.action_pressed.connect(_on_action_pressed)

func _on_action_pressed(action: String, delta: float) -> void:
	match action:
		"move_right":
			_move_right(delta)
		"move_left":
			_move_left(delta)

func _move_right(delta) -> void:
	position.x += 1 * SPEED * delta
	_clamp_position()

func _move_left(delta) -> void:
	position.x += -1 * SPEED * delta
	_clamp_position()

func _clamp_position() -> void:
	var half_width: float = $CollisionShape2D.shape.size.x / 2.0
	var screen_width := get_viewport_rect().size.x
	position.x = clamp(position.x, half_width, screen_width - half_width)
