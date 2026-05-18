extends PowerUp

class_name ExplosionPowerUp

var explosion_area
var level

func _init(level_scene):
	icon = load("res://assets/sprites/powerups/explosion_icon.png")
	explosion_area = preload("res://scenes/explosion_area.tscn")
	level = level_scene

func activate(kwargs: Dictionary = {}):
	var ea = explosion_area.instantiate()
	ea.position = kwargs["position"]
	level.add_child(ea)
	ea.start()
