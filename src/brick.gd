extends RigidBody2D

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: CanvasGroup = $CanvasGroup
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var multiplier_given : float
var score_given : int
var brick_type : String
var color : Color

func set_brick_type() -> void:
	match brick_type:
		"RED": 
			score_given = 5
			color = Color.RED
			multiplier_given = 0.4
		"GREEN": 
			score_given = 2
			color = Color.GREEN
			multiplier_given = 0.3
			
		"BLUE": 
			score_given = 1
			color = Color.BLUE
			multiplier_given = 0.1
			
	modulate = color
	
func _play_hit_animation():
	animation_player.play("hit")
	
func hit(ball_pos : Vector2):
	'''Called when hit by ball'''
	angular_velocity = get_angle_to(ball_pos) * 8
	gravity_scale = 0.2
	var direction = -1.0 * global_position.direction_to(ball_pos)
	var upward_force = Vector2.UP * randf_range(20 , 80)
	apply_impulse(direction * 100 + upward_force)
	collision.disabled = true
	_play_hit_animation()
	GameManager.game_score += score_given
	GameManager.game_multiplier = clampf(GameManager.game_multiplier + multiplier_given , 1.0 , 2.5)
	await get_tree().create_timer(1).timeout
	queue_free()
