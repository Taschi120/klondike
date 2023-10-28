extends CardStack

class_name Foundation

@export var suit = "heart"

func get_current_value() -> int:
	return size()

func get_region():
	return Regions.FOUNDATION

func _on_selection_changed(cards, source):
	if cards.is_empty():
		
