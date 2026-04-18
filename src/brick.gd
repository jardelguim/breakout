extends RigidBody2D

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: CanvasGroup = $CanvasGroup
@onready var animation_player: AnimationPlayer = $AnimationPlayer


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
	await get_tree().create_timer(1).timeout
	queue_free()
