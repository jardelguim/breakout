extends Node

@onready var sound_container = get_node("/root/Game/SoundContainer")

var sound_list = {
	"bounce_screen_side" : "res://assets/sounds/Ball bounce off the sides of the screen.wav",
	"bounce_paddle" : "res://assets/sounds/Ball bounce off the player paddle.wav",
	"hit_normal" : "res://assets/sounds/Ball bounce off normal brick - destroy.wav"
}

func play_sound(sound_id : String ):
	var sound_player = AudioStreamPlayer.new()
	var sound = load(sound_list[sound_id])
	sound_container.add_child(sound_player)
	sound_player.stream = sound
	sound_player.play()
	await sound_player.finished
	sound_player.queue_free()
