extends Control

class_name MySettingsWindow

signal quit_button_pressed
signal about_button_pressed
signal settings_button_pressed
signal return_to_game_pressed
signal new_game_button_pressed


func _on_return_to_game_pressed() -> void:
	return_to_game_pressed.emit()

func _on_start_button_pressed() -> void:
	new_game_button_pressed.emit()

func _on_settings_button_pressed() -> void:
	settings_button_pressed.emit()

func _on_about_button_pressed() -> void:
	about_button_pressed.emit()
	
func _on_quit_button_pressed() -> void:
	quit_button_pressed.emit()
