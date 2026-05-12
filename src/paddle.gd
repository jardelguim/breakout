extends CharacterBody2D

signal speed_powerup
signal speed_ended
signal size_powerup
signal size_ended

@export var ghost_sprite : PackedScene
@onready var fire_particles: GPUParticles2D = $FireParticles
@onready var ghost_spawn_timer: Timer = $GhostSpawnTimer
var base_speed = 300
var color = Color.BLACK
var object_sound = SoundManager.paddle_list
var speed_up_flag: bool = false
var size_up_flag : bool = false
var acceleration = 0.2

func _ready() -> void:
	InputManager.action_pressed.connect(_on_action_pressed)

func _physics_process(_delta: float) -> void:
	fire_particles.amount_ratio = ScoreCalculator.multiplier - 1.5
	
func _on_action_pressed(action: String, delta: float) -> void:
	match action:
		"move_right":
			_move_right(delta)
		"move_left":
			_move_left(delta)

func _move_right(delta) -> void:
	position.x += 1 * base_speed * delta
	_clamp_position()

func _move_left(delta) -> void:
	position.x += -1 * base_speed * delta
	_clamp_position()

func _clamp_position() -> void:
	var half_width: float = $ClampCollision.shape.height / 2.0
	var screen_width := get_viewport_rect().size.x
	position.x = clamp(position.x, half_width, screen_width - half_width)

func hit(_value):
	$AnimationPlayer.play("hit")
	
func wider_paddle():
	if size_up_flag == false:
		$AnimationPlayer.play("size_up")
		size_powerup.emit()
		size_up_flag = true
	$WiderTimer.start()
	$WiderTimer.wait_time = clamp($WiderTimer.time_left + 2.0 , 0.0 , 10.0 )
	
func speed_up():
	if speed_up_flag == false:
		speed_powerup.emit()
	speed_up_flag = true
	$SpeedTimer.start()
	$SpeedTimer.wait_time = clamp($SpeedTimer.time_left + 2.0 , 0.0 , 10.0 )
	base_speed = clamp(base_speed + 100, 300, 500)

func _add_ghost():
	var ghost = ghost_sprite.instantiate()
	ghost.set_property(position , scale)
	get_parent().add_child(ghost)
	
func _on_speed_timer_timeout() -> void:
	$SpeedTimer.wait_time = 5.0
	speed_up_flag = false
	speed_ended.emit()
	base_speed = 300

func _on_wider_timer_timeout() -> void:
	$WiderTimer.wait_time = 5.0
	$AnimationPlayer.play_backwards("size_up")
	size_up_flag = false
	size_ended.emit()

func _on_ghost_spawn_timer_timeout() -> void:
	if speed_up_flag:
		_add_ghost()
