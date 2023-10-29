extends Control

class_name CheatUI

signal win

func _ready() -> void:
	if OS.is_debug_build():
		visible = true

func _on_win_button_pressed() -> void:
	win.emit()
