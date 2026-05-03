extends RigidBody2D

@onready var collision: CollisionShape2D = $CollisionShape2D
var is_alive = true
var brick_type : String
var color : Color
var texture

func _ready() -> void:
	brick_type = BrickData.brick_types.pick_random()
	set_brick_type()
	angular_velocity = randf_range(-10 , 10)
	
	
func _physics_process(delta: float) -> void:
	pass
	
func set_brick_type() -> void:
	match brick_type:
		"RED": 
			color = Color.RED
			texture = load("res://assets/sprites/bricks/red_brick.png")
		"GREEN":
			color = Color.GREEN
			texture = load("res://assets/sprites/bricks/green_brick.png")
		"BLUE": 
			color = Color.BLUE	
			texture = load("res://assets/sprites/bricks/blue_brick.png")
		"YELLOW": 
			color = Color.YELLOW
			texture = load("res://assets/sprites/bricks/yellow_brick.png")
			
	%BrickSprite.texture = texture
	#modulate.a = 0.0
		
func hit(ball_pos : Vector2):
	'''Called when hit by ball'''
	_apply_ball_impulse(ball_pos)
	
func _apply_ball_impulse(ball_pos):
	var angular_vel_multi = 8
	var direction = -1.0 * global_position.direction_to(ball_pos)
	var upward_force = Vector2.UP * randf_range(20 , 80)
	angular_velocity = get_angle_to(ball_pos) * angular_vel_multi
	apply_impulse(direction * 100 + upward_force)
	gravity_scale = 0.2
	
func _on_del_timer_timeout() -> void:
	queue_free()
