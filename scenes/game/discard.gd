extends CardStack

class_name DiscardPile

func get_region():
	return Regions.DISCARD
	
func add_card(_card):
	if not is_empty():
		peek().set_deferred("at_top", false)
	super.add_card(_card)
	_card.position = Vector2.ZERO
	_card.set_deferred("open", true)
	_card.set_deferred("at_top", true)
