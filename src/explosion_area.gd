extends Area2D

func start():
	print("exploded")
	$AnimationPlayer.play("increase_area")
	$BigExplosionParticles.emitting = true
	await get_tree().create_timer($BigExplosionParticles.lifetime).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit(position)
