extends Control

class_name CheatUI

signal win

func _on_win_button_pressed() -> void:
	win.emit()
