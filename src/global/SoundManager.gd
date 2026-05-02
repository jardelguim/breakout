extends Node

@onready var sound_container = get_node("/root/Game/SoundContainer")

var wall_list = {
	"wall_hit_1" : "res://assets/sounds/wall_hit_1.wav",
	"wall_hit_2" : "res://assets/sounds/wall_hit_2.wav",
}
var paddle_list = {
	"paddle_bounce_1" : "res://assets/sounds/paddle_bounce_1.wav",
	"paddle_bounce_2" : "res://assets/sounds/paddle_bounce_2.wav",
}
var brick_list = {
	"brick_hit_1" : "res://assets/sounds/brick_hit_1.wav", 
	"brick_hit_2" : "res://assets/sounds/brick_hit_2.wav",
	"brick_hit_3" : "res://assets/sounds/brick_hit_3.wav",
}

func play_sound(sound_list):
	var sound_player = AudioStreamPlayer.new()
	var sound_id = sound_list.keys().pick_random()
	var sound = load(sound_list[sound_id])
	sound_container.add_child(sound_player)
	sound_player.stream = sound
	sound_player.play()
	await sound_player.finished
	sound_player.queue_free()
