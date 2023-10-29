extends Control

class_name SettingsWindow

signal sfx_toggled
signal music_toggled
signal exit_button_clicked

func _ready() -> void:
	# TODO Read settings here!
	$PanelContainer/MarginContainer/VBoxContainer/SFXToggle.set_pressed_no_signal(false)
	$PanelContainer/MarginContainer/VBoxContainer/MusicToggle.set_pressed_no_signal(false)
	
	_on_sfx_toggle_toggled(false)
	_on_music_toggle_toggled(false)

func _on_sfx_toggle_toggled(button_pressed: bool) -> void:
	sfx_toggled.emit(button_pressed)

func _on_music_toggle_toggled(button_pressed: bool) -> void:
	music_toggled.emit(button_pressed)

func _on_exit_button_pressed() -> void:
	exit_button_clicked.emit()
