extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print(body.name + "entered")
	if body.has_method("entered_killzone"):
		body.entered_killzone()
