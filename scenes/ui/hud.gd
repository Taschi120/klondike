extends Control

class_name HUD

signal settings_button_clicked

func _on_settings_button_pressed() -> void:
	settings_button_clicked.emit()
