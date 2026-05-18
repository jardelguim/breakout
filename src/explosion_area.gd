extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func destroy():
	queue_free()

func start():
	$AnimationPlayer.play("increase_area")
	await $AnimationPlayer.animation_finished
	destroy()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit(position)
