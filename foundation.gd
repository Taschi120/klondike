extends Area2D

@export var suit = "heart"

func get_current_value() -> int:
	return get_child_count() - 2

func add_card(_card) -> void:
	add_child(_card)
	_card.at_top = false
