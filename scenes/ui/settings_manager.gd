extends Node

# TODO persist these
var music_enabled = true: set = set_music_enabled
var sfx_enabled = true: set = set_sfx_enabled

func set_music_enabled(value: bool) -> void:
	var idx = AudioServer.get_bus_index("Music")
	assert(idx >= 0)
	AudioServer.set_bus_mute(idx, value)

func set_sfx_enabled(value: bool) -> void:
	var idx = AudioServer.get_bus_index("SFX")
	assert(idx >= 0)
	AudioServer.set_bus_mute(idx, value)
