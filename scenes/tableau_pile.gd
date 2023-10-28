extends CardStack

class_name TableauPile

const FACEDOWN_OFFSET = Vector2(0, 5)
const FACEUP_OFFSET = Vector2(0, 35)

func add_card(_card):
	super.add_card(_card)
	reorg_stack()
	
func remove_card(_card):
	super.remove_card(_card)
	reorg_stack()
	
func take_top_card():
	var result = super.take_top_card()
	reorg_stack()
	return result
	
func take_top_cards(from: Card) -> Array:
	var result = Array()
	var idx = $Internal.get_children().find(from)
	assert(idx >= 0)
	for i in range(idx, $Internal.get_child_count()):
		result.append($Internal.get_child(i))
		
	for card in result:
		# avoid call to "reorg_stack()"
		super.remove_card(card)
		
	reorg_stack()
	return result

# Reposition cards so they are all visible
func reorg_stack():
	var child_count = size()
	if is_empty():
		$DropoffSpot.position = Vector2.ZERO
		return
	
	var offset = Vector2(0, 0)
	
	var card = $Internal.get_child(0)

	card.position = offset
	var previous_card_open = card.open

	for i in range(1, child_count):
		if previous_card_open:
			offset += FACEUP_OFFSET
		else:
			offset += FACEDOWN_OFFSET
			
		card = $Internal.get_child(i)
		card.position = offset
		previous_card_open = card.open
		
	$DropoffSpot.position = $Internal.get_child(child_count - 1).position
		
func get_region():
	return Regions.TABLEAU
	
func can_accept(_cards: Array, _source: CardStack) -> bool:
	if _cards.is_empty():
		return false
		
	if self == _source:
		return true # return cards to their origin
		
	if _cards[0].value == 13 and self.is_empty():
		return true # Dropping king on empty stack

	if self.is_empty():
		return false

	var top_card = peek()
	if _cards[0].value == top_card.value - 1 and _cards[0].get_color() != top_card.get_color():
		return true
		
	return false
