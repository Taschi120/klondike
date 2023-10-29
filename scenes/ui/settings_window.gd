extends Control

class_name SettingsWindow

signal sfx_toggled
signal music_toggled
signal exit_button_clicked

func _on_sfx_toggle_toggled(button_pressed: bool) -> void:
	sfx_toggled.emit(button_pressed)

func _on_music_toggle_toggled(button_pressed: bool) -> void:
	music_toggled.emit(button_pressed)

func _on_exit_button_pressed() -> void:
	exit_button_clicked.emit()
