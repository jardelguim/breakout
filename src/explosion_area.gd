extends Area2D

func start():
	$AnimationPlayer.play("increase_area")
	$BigExplosionParticles.emitting = true
	SoundManager.play_sound(SoundManager.explosion_list)
	await get_tree().create_timer($BigExplosionParticles.lifetime).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit(position , 3.0 , true)
