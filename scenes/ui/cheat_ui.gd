extends Control

class_name CheatUI

signal win

@onready var stock: Stock = get_tree().root.get_node("MainScreen/Stock")

func _ready() -> void:
	if OS.is_debug_build():
		visible = true
		
func _process(delta: float) -> void:
	$CardsInStock.text = "Cards in stock: " + str(stock.size())

func _on_win_button_pressed() -> void:
	win.emit()
