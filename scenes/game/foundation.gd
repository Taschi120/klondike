extends CardStack

class_name Foundation

var suit = "undefined"

signal card_added

func add_card(_card) -> void:
	suit = _card.suit
	super.add_card(_card)
	card_added.emit()

func get_current_value() -> int:
	return size()

func get_region():
	return Regions.FOUNDATION

func can_accept(cards: Array, source: CardStack) -> bool:
	if cards.size() != 1:
		return false
		
	if source.get_region() not in [Regions.DISCARD, Regions.TABLEAU]:
		return false
		
	if cards[0].value != get_current_value() + 1:
		return false
		
	if suit != cards[0].suit and suit != "undefined":
		return false
		
	return true
