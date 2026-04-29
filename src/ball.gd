extends CharacterBody2D

@onready var particle_emitter: ParticleEmitter = %ParticleEmitter
@onready var fire_particles: GPUParticles2D = $FireParticles
var ball_velocity = velocity * velocity_multiplier
var velocity_multiplier : float = 1.0
var base_speed = 150
var dir = Vector2.UP
var is_active = false

func _reset_vel():
	velocity = Vector2(base_speed , base_speed)
	velocity_multiplier = 1.0

func _ready() -> void:
	_reset_vel()

func _physics_process(delta: float) -> void:
	# If active, moves the ball based on the velocity
	fire_particles.amount_ratio = velocity_multiplier - 1.0
	rotate(5 * velocity_multiplier * delta)
	if not is_active:
		return

	var collision = move_and_collide(velocity * velocity_multiplier * delta) 
	if not collision:
		return

	var collider_node = collision.get_collider()
	if collider_node.name == "FloorWall":
		entered_killzone()
		
	# Bounces to opposite direction when collision with another collision shape
	
	velocity = velocity.bounce(collision.get_normal())
	var particle_direction = Vector3(collision.get_normal().x , collision.get_normal().y , 0)
	var particle_color = Color.BLACK
		
	if collision.get_collider().has_method("hit"):
		particle_color = collider_node.color
		collision.get_collider().hit(global_position)
		velocity_multiplier = clamp(velocity_multiplier + 0.1 , 1.0 , 2.0)
		
	particle_emitter.emit_particle("explosion" , global_position , particle_direction.normalized() , true , particle_color)

	if(velocity.y > 0 and velocity.y < 100):
		velocity.y = -150

	if velocity.x == 0:
		velocity.x = -150

func entered_killzone():
	_reset_vel()
	ScoreCalculator.reset_chain()

func switch_active_state():
	is_active = not is_active
	print(is_active)
