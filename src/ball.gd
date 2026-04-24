extends CharacterBody2D

@onready var trails: Trails = $Trails


var speed = 150
var dir = Vector2.UP
var is_active = true

func _ready() -> void:
	velocity = Vector2(speed , speed)

func _physics_process(delta: float) -> void:
	# If active, moves the ball based on the velocity
	if is_active:
		rotate(20)
		var collision = move_and_collide(velocity * delta)
		
		if collision:
			var collider_node = collision.get_collider()
			if collider_node.name == "FloorWall":
				entered_killzone()
			# Bounces to opposite direction when collision with another collision shape
			velocity = velocity.bounce(collision.get_normal())
			if collision.get_collider().has_method("hit"):
				collision.get_collider().hit(global_position)
				velocity *= 1.01
				
			
		if(velocity.y > 0 and velocity.y < 100):
			velocity.y = -150
	
		if velocity.x == 0:
			velocity.x = -150

func entered_killzone():
	velocity = Vector2(speed , speed)
	GameManager.game_multiplier = 1.0
