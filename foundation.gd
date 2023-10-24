extends Area2D

@export var suit = "heart"

func get_current_value() -> int:
	return $CardStack.get_child_count()

