# Meu gerenciador genérico de INPUT, basta adicionar como Singleton no Godot
extends Node

# sinais
signal action_pressed(action: String)
signal action_released(action: String)
signal action_just_pressed(action: String)

func _physics_process(delta: float):
	for action in InputMap.get_actions():
		if action.is_empty():
			return

		if Input.is_action_pressed(action):
			action_pressed.emit(action, delta)
		if Input.is_action_just_released(action):
			action_released.emit(action, delta)
		if Input.is_action_just_pressed(action):
			action_just_pressed.emit(action, delta)
