extends Control

class_name InfoWindow

signal close_button_clicked

func _on_close_button_pressed() -> void:
	close_button_clicked.emit()
