extends Node

# TODO persist these
var music_muted = true: set = set_music_muted
var sfx_muted = true: set = set_sfx_muted

func set_music_muted(value: bool) -> void:
	var idx = AudioServer.get_bus_index("Music")
	assert(idx >= 0)
	AudioServer.set_bus_mute(idx, value)

func set_sfx_muted(value: bool) -> void:
	var idx = AudioServer.get_bus_index("SFX")
	assert(idx >= 0)
	AudioServer.set_bus_mute(idx, value)
