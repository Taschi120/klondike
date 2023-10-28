extends CardStack

class_name Foundation

@export var suit = "heart"

func get_current_value() -> int:
	return size()

func get_region():
	return Regions.FOUNDATION

func can_accept(cards: Array, source: CardStack) -> bool:
	if cards.size() != 1:
		return false
		
	if source.get_region() not in [Regions.DISCARD, Regions.FOUNDATION]:
		return false
		
	if suit != cards[0].suit:
		return false
		
	if cards[0].value != get_current_value() + 1:
		return false
		
	return true
