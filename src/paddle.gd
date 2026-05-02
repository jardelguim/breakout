extends CharacterBody2D

@export var SPEED := 200.0
var color = Color.BLACK
var object_sound = SoundManager.paddle_list
var quick_mode_flag: bool = false
var acceleration = 0.2

func _ready() -> void:
	InputManager.action_pressed.connect(_on_action_pressed)

func _on_action_pressed(action: String, delta: float) -> void:
	match action:
		"move_right":
			_move_right(delta)
		"move_left":
			_move_left(delta)

func _move_right(delta) -> void:
	velocity.x = lerp(velocity.x, 1 * SPEED, acceleration)
	velocity.y = 0
	move_and_slide()
	_clamp_position()

func _move_left(delta) -> void:
	velocity.x = lerp(velocity.x, -1 * SPEED, acceleration)

	velocity.y = 0
	move_and_slide()
	_clamp_position()

func _clamp_position() -> void:
	var half_width: float = $PaddleCollision.shape.height / 2.0
	var screen_width := get_viewport_rect().size.x
	position.x = clamp(position.x, half_width, screen_width - half_width)

func hit(_value):
	$AnimationPlayer.play("reaction")
