extends RigidBody2D

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var multiplier_given : float
var score_given : int
var brick_type : String
var color : Color
var texture

func set_brick_type() -> void:
	match brick_type:
		"RED": 
			score_given = 3
			color = Color.RED
			multiplier_given = 0.1
			texture = load("res://assets/sprites/bricks/red_brick.png")
			
		"GREEN": 
			score_given = 2
			color = Color.GREEN
			multiplier_given = 0.1
			texture = load("res://assets/sprites/bricks/green_brick.png")
			
		"BLUE": 
			score_given = 1
			color = Color.BLUE
			multiplier_given = 0.1
			texture = load("res://assets/sprites/bricks/blue_brick.png")
			
		"YELLOW": 
			score_given = 1
			color = Color.YELLOW
			multiplier_given = 0.1
			texture = load("res://assets/sprites/bricks/yellow_brick.png")
			
	$%BrickSprite.texture = texture
	modulate.a = 0.0
		
func _play_die_animation():
	animation_player.play("die")
	
func _play_hit_animation():
	color = Color.GRAY
	var tween = create_tween()
	tween.tween_property($%BrickSprite.material, "shader_parameter/weight", 1.0, 0.5)
	
func hit(ball_pos : Vector2):
	'''Called when hit by ball'''
	angular_velocity = get_angle_to(ball_pos) * 8
	_play_hit_animation()
	gravity_scale = 0.2
	var direction = -1.0 * global_position.direction_to(ball_pos)
	var upward_force = Vector2.UP * randf_range(20 , 80)
	apply_impulse(direction * 100 + upward_force)
	ScoreCalculator.add_multiplier(multiplier_given)
	BrickData.bricks_array.erase(self)
	_change_collision_layer()

func _change_collision_layer():
	set_collision_layer_value(1 , false)
	set_collision_mask_value(1 , false)
	set_collision_layer_value(2 , true)
	set_collision_mask_value(2 , true)
	
func entered_killzone():
	set_deferred("collision" , false)
	_play_die_animation()
	gravity_scale = 0
	linear_velocity.y = 20
	ScoreCalculator.add_score_with_multiplication(score_given)
	await get_tree().create_timer(1).timeout
	queue_free()
