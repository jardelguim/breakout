# Meu gerenciador genérico de INPUT, basta adicionar como Singleton no Godot
extends Node

# sinais
signal action_pressed(action: String)
signal action_released(action: String)


func _input(event: InputEvent) -> void:
	if not event is InputEventAction:
		return

	var action := _get_action_name(event)
	if action.is_empty():
		return

	if event.is_pressed() and not event.is_echo():
		action_pressed.emit(action)
	elif event.is_released():
		action_released.emit(action)

func is_held(action: String) -> bool:
	return Input.is_action_pressed(action)

func is_just_pressed(action: String) -> bool:
	return Input.is_action_just_pressed(action)

func is_just_released(action: String) -> bool:
	return Input.is_action_just_released(action)

func get_paddle_direction() -> float:
	return Input.get_axis("move_left", "move_right")

func _get_action_name(event: InputEvent) -> String:
	for action in InputMap.get_actions():
		if InputMap.action_has_event(action, event):
			return action
	return ""
