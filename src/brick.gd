extends RigidBody2D

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

func hit():
	'''Called when hit by ball'''
	collision.disabled = true
	sprite.visible = false
	await get_tree().create_timer(1).timeout
	queue_free()
