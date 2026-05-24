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

func hit(_value , _value2 , _value3):
	$AnimationPlayer.play("hit")
	
func wider_paddle():
	if size_up_flag == false:
		#$AnimationPlayer.play("size_up")
		var tween = create_tween()
		tween.tween_property(self , "scale:x" , 1.5 , 0.5)
		size_powerup.emit()
		size_up_flag = true
		SoundManager.play_sound(SoundManager.size_up_list)
	if $WiderTimer.is_stopped():
		$WiderTimer.start()
	else:
		$WiderTimer.start(clamp($WiderTimer.time_left + 2.0 , 0.0 , 10.0))
	
func speed_up():
	if speed_up_flag == false:
		speed_powerup.emit()
		SoundManager.play_sound(SoundManager.speed_up_list)
	speed_up_flag = true
	if $SpeedTimer.is_stopped():
		$SpeedTimer.start()
	else:
		$SpeedTimer.start(clamp($SpeedTimer.time_left + 2.0 , 0.0 , 10.0))
	base_speed = clamp(base_speed + 100, 300, 500)

func _add_ghost():
	var ghost = ghost_sprite.instantiate()
	ghost.set_property(position , scale)
	get_parent().add_child(ghost)
	
func _on_speed_timer_timeout() -> void:
	SoundManager.play_sound(SoundManager.speed_down_list)
	speed_up_flag = false
	speed_ended.emit()
	base_speed = 300

func _on_wider_timer_timeout() -> void:
	$AnimationPlayer.play("size_down")
	SoundManager.play_sound(SoundManager.size_down_list)
	size_up_flag = false
	size_ended.emit()

func _on_ghost_spawn_timer_timeout() -> void:
	if speed_up_flag:
		_add_ghost()

func _on_ball_lost_streak() -> void:
	SoundManager.play_selected_sound("generic4")
	$PaddleCollision.disabled = true
	await get_tree().create_timer(0.5).timeout
	$PaddleCollision.disabled = false
