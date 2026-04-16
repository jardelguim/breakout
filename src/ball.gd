extends CharacterBody2D

var speed = 150
var dir = Vector2.UP
var is_active = true

func _ready() -> void:
	velocity = Vector2(speed * 1 , speed)
	
func _physics_process(delta: float) -> void:
	# If active, moves the ball based on the velocity
	if is_active:
		var collision = move_and_collide(velocity * delta)
		
		if collision:
			# Bounces to opposite direction when collision with another collision shape
			velocity = velocity.bounce(collision.get_normal())
			if collision.get_collider().has_method("hit"):
				collision.get_collider().hit(global_position)
				print(velocity)
				velocity *= 1.03
			
		#if(velocity.y > 0 and velocity.y < 100):
		#	velocity.y = -200
	
		#if velocity.x == 0:
		#	velocity.x = -200
		
		
	
