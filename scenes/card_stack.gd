extends Node2D

class_name CardStack

@export var type = Regions.DRAW

func add_card(_card):
	$Internal.add_child(_card)
	_card.position = Vector2.ZERO
	
func add_cards(stack: Array) -> void:
	for card in stack:
		add_card(card)
	
func remove_card(_card):
	$Internal.remove_child(_card)
	
func is_empty():
	return $Internal.get_child_count() == 0
	
func size():
	return $Internal.get_child_count()
	
func peek():
	var child_count = $Internal.get_child_count()
	assert(child_count > 0)
	return $Internal.get_child(child_count - 1)
	
func take_top_card():
	var child_count = $Internal.get_child_count()
	assert(child_count > 0)
	var result = $Internal.get_child(child_count - 1)
	$Internal.remove_child(result)
	return result
		
func get_region():
	assert(false) # needs to be overridden in every implementation

func contains(_card) -> bool:
	return $Internal.get_children().has(_card)
