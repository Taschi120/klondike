extends Control

class_name CongratulationsDialog

signal play_again

func _on_yes_button_pressed() -> void:
	play_again.emit()

func _on_no_button_pressed() -> void:
	print("Congratulations dialog - quitting game")
	get_tree().quit()
