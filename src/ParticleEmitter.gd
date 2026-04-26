extends Node
class_name ParticleEmitter

@export var particle_mapper : Dictionary[String , String] = {
	
}

func _ready() -> void:
	pass

func emit_particle(particle_id : String , position : Vector2 , angle : Vector3 , isOneShot : bool , color : Color):
	var particle_dir : String = particle_mapper[particle_id]
	var new_particle = load(particle_dir).instantiate()
	new_particle.global_position = position
	new_particle.process_material.set("direction", angle )
	new_particle.one_shot = isOneShot
	new_particle.process_material.set("color", color )
	add_child(new_particle)
	await get_tree().create_timer(new_particle.lifetime).timeout
	new_particle.queue_free()
